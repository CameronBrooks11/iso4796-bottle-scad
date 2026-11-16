"""Check iso4796.scad and the maker rows against their sources, and render the bottles.

usage: python3 tests/test_iso4796.py [OPENSCAD]

din168-thread-scad has to be on OPENSCADPATH: `just test` puts it there with
`scadman env`.

- Every ISO row matches Table 1 as docs/references.md records it, and every
  DURAN and KIMAX row matches its maker's figures there.
- What each drawn bottle holds, to the shoulder, to the neck and (for DURAN)
  to the rim, rounds to the percentages docs/references.md's Findings record,
  which the README quotes.
- Every bottle renders as one solid, d1 across and h1 tall; with the thread
  drawn too, on each of the three finishes; and every example renders.
- The lookups refuse a capacity they don't have, with their messages.
"""

import json
import os
import re
import struct
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
REFERENCES = os.path.join(ROOT, "docs", "references.md")
INCLUDE = "".join(f"include <{os.path.join(ROOT, f)}>\n" for f in ("iso4796.scad", "duran.scad", "kimax.scad"))


def run(openscad, source, out, tmp):
    path = os.path.join(tmp, "probe.scad")
    with open(path, "w") as f:
        f.write(INCLUDE + source)
    cmd = [openscad, "--hardwarnings", "-o", out]
    if out.endswith(".stl"):
        cmd += ["--export-format", "binstl"]
    return subprocess.run(cmd + [path], capture_output=True, text=True)


def echoes(result):
    return [json.loads(re.sub(r"\bundef\b", "null", l.split("ECHO: ", 1)[1]))
            for l in result.stderr.splitlines() if l.startswith("ECHO: ")]


def measure(path):
    data = open(path, "rb").read()
    (n,) = struct.unpack_from("<I", data, 80)
    parent = {}

    def find(v):
        while parent[v] != v:
            parent[v] = parent[parent[v]]
            v = parent[v]
        return v

    for i in range(n):
        v = struct.unpack_from("<9f", data, 84 + i * 50 + 12)
        corners = [v[0:3], v[3:6], v[6:9]]
        for c in corners:
            parent.setdefault(c, c)
        root = find(corners[0])
        for c in corners[1:]:
            parent[find(c)] = root
    solids = len({find(v) for v in parent})
    size = [max(p[i] for p in parent) - min(p[i] for p in parent) for i in range(3)]
    return solids, size


def number(cell):
    return float(cell.replace(" ", "").split("(")[0])


def section(heading):
    text = open(REFERENCES, encoding="utf-8").read()
    return text.split(heading, 1)[1].split("\n## ", 1)[0]


def table_rows(text):
    """The rows of every Markdown table in text, header included, as lists of cells."""
    rows = []
    for line in text.splitlines():
        if line.startswith("|") and not re.match(r"\|\s*-", line):
            rows.append([c.strip() for c in line.strip().strip("|").split("|")])
    return rows


def tables(text):
    """Each Markdown table in text, as its rows."""
    found, current = [], []
    for line in text.splitlines() + [""]:
        if line.startswith("|"):
            current.append(line)
        elif current:
            found.append(table_rows("\n".join(current)))
            current = []
    return found


results = []


def check(label, ok, got):
    results.append(bool(ok))
    print(f"{'ok  ' if ok else 'FAIL'} {label}: {got}")


def main():
    openscad = sys.argv[1] if len(sys.argv) > 1 else "openscad"
    with tempfile.TemporaryDirectory() as tmp:
        csg = os.path.join(tmp, "out.csg")
        stl = os.path.join(tmp, "out.stl")

        r = run(openscad, "include <din168-thread-scad/din168.scad>\n", csg, tmp)
        if r.returncode != 0 or "WARNING" in r.stderr:
            sys.exit("din168-thread-scad isn't on OPENSCADPATH; run `just test`, which sets it "
                     "with `scadman env`.")

        r = run(openscad, "echo(iso4796_sizes);\necho(duran_bottles);\necho(kimax_bottles);\n", csg, tmp)
        iso, duran, kimax = echoes(r)

        # ISO Table 1: [mL, h1, h2, d1, s, d2]
        table = [[number(c) for c in row] for row in table_rows(section("### Table 1"))[1:]]
        ours = [[s[1], s[2], s[3], s[4], s[5], s[6]] for s in iso]
        check("ISO rows match Table 1", ours == table,
              f"{len(ours)} rows" if ours == table else f"{ours} against {table}")

        # DURAN: catalogue number, mL, GL, d, h; and brim capacities.
        dwk = section("## DURAN Original GL 45")
        rows = table_rows(dwk)
        sheet = {number(r[1]): r for r in rows[1:] if r[0][0].isdigit() and len(r) == 5}
        brim_head, brim_vals = rows[-2], rows[-1]
        brims = {number(m): number(b) for m, b in zip(brim_head[1:], brim_vals[1:])}
        bad = []
        for row in duran:
            name, ml, h, _, d = row[0], row[1], row[2], row[3], row[4]
            src = sheet.get(ml)
            if src is None or name != f"DURAN {src[0]}" and src[0] not in name \
                    or number(src[3]) != d or number(src[4]) != h or (len(row) > 8 and row[8] != brims.get(ml)):
                bad.append(name)
        check("DURAN rows match DWK's sheet and brim capacities", not bad, bad or f"{len(duran)} rows")

        # KIMAX: OD and height are Table 1's d1 and h1.
        by_ml = {s[1]: s for s in iso}
        bad = [k[0] for k in kimax if (k[2], k[4]) != (by_ml[k[1]][2], by_ml[k[1]][4])]
        check("KIMAX rows are Table 1's d1 and h1", not bad, bad or f"{len(kimax)} rows")

        # Capacities against Findings.
        caps, rim_table = tables(section("## Findings"))
        shoulder = {number(r[0]): (number(r[1]), number(r[2])) for r in caps[1:]}
        rim_head, rim_vals = rim_table
        rims = {number(m): number(v) for m, v in zip(rim_head[1:], rim_vals[1:])}
        source = "".join(
            f"echo(let (s = iso4796_by_capacity({ml:g})) [100 * iso4796_volume_below(s, iso4796_shoulder_height(s)) / {ml:g},"
            f" 100 * iso4796_volume_below(s, iso4796_neck_base_z(s)) / {ml:g}]);\n" for ml in shoulder)
        source += "".join(
            f"echo(let (d = duran_by_capacity({ml:g})) 100 * iso4796_volume_below(d, iso4796_height(d)) / {b:g});\n"
            for ml, b in brims.items())
        got = echoes(run(openscad, source, csg, tmp))
        check("Findings has a capacity row for every size, and DURAN rim figures",
              len(shoulder) == len(iso) and len(rims) == 11 and len(got) == len(shoulder) + len(rims),
              f"{len(shoulder)} sizes, {len(rims)} rim figures, {len(got)} computed")
        for (ml, (want_s, want_n)), (s, n) in zip(shoulder.items(), got[:len(shoulder)]):
            check(f"{ml:g} mL holds what Findings records", round(s) == want_s and round(n) == want_n,
                  f"{s:.1f} % to the shoulder, {n:.1f} % to the neck; recorded {want_s:g} and {want_n:g}")
        for (ml, want), r_pct in zip(rims.items(), got[len(shoulder):]):
            check(f"DURAN {ml:g} mL to the rim", round(r_pct) == want,
                  f"{r_pct:.1f} % of the brim capacity; recorded {want:g}")

        # Renders.
        def bottle(label, call, size, h, d):
            r = run(openscad, call + "\n", stl, tmp)
            bad = [l for l in r.stderr.splitlines() if "WARNING" in l or "ERROR" in l]
            if r.returncode != 0 or bad:
                check(label, False, bad[:1] or f"exit {r.returncode}")
                return
            solids, got_size = measure(stl)
            # A revolved section is d1 across from a vertex on x, and a facet narrower on y.
            ok = solids == 1 and abs(got_size[2] - h) <= 0.01 and abs(got_size[0] - d) <= 0.01 \
                and d * 0.99 <= got_size[1] <= d + 0.01
            check(label, ok, f"{solids} solid(s), {got_size[0]:.2f} x {got_size[1]:.2f} x {got_size[2]:.2f}; "
                  f"expected 1, {d:g} across, {h:g} tall")

        for s in iso:
            bottle(f"{s[1]:g} mL bottle", f"iso4796_bottle(iso4796_by_capacity({s[1]:g}), n = 8);",
                   s, s[2], s[4])
        for ml in (25, 50, 500):
            s = by_ml[ml]
            bottle(f"{ml} mL bottle with its {s[7][0]} thread",
                   f"iso4796_bottle(iso4796_by_capacity({ml}), thread = true, n = 8);", s, s[2], s[4])
        bottle("DURAN 3 500 mL bottle (160 across, where ISO says 161)",
               "iso4796_bottle(duran_by_capacity(3500), n = 8);", None, 295, 160)

        for name in sorted(os.listdir(os.path.join(ROOT, "examples"))):
            if not name.endswith(".scad"):
                continue
            r = subprocess.run([openscad, "--hardwarnings", "--export-format", "binstl", "-o", stl,
                                os.path.join(ROOT, "examples", name)], capture_output=True, text=True)
            bad = [l for l in r.stderr.splitlines() if "WARNING" in l or "ERROR" in l]
            check(f"examples/{name} renders", r.returncode == 0 and not bad, bad[:1] or "clean")

        # Refusals.
        for label, call, message in [
            ("refuses an ISO size it doesn't have", "echo(iso4796_by_capacity(300));",
             "no ISO 4796-1 bottle of 300 mL"),
            ("refuses a DURAN size it doesn't have", "echo(duran_by_capacity(300));",
             "no DURAN Original bottle of 300 mL"),
            ("refuses a KIMAX size it doesn't have", "echo(kimax_by_capacity(25));",
             "no KIMAX GL45 media bottle of 25 mL"),
        ]:
            r = run(openscad, call + "\n", csg, tmp)
            errors = [l for l in r.stderr.splitlines() if "ERROR" in l]
            check(label, errors and message in errors[0],
                  errors[0] if errors else f"exit {r.returncode}, no error")

    print(f"{sum(results)} of {len(results)} checks passed")
    sys.exit(0 if all(results) else 1)


main()
