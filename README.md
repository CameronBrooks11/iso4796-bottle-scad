# iso4796-bottle-scad

ISO 4796-1 screw-neck laboratory bottles (the DURAN / KIMAX-style media bottle) in OpenSCAD: the
standard's size table, a section built from it, what each bottle holds, and a drawing with the
DIN 168 thread optional.

```openscad
use <iso4796-bottle-scad/iso4796.scad>

b = iso4796_by_capacity(500);
iso4796_bottle(b);                  // the bottle, base on z = 0, thread band as a plain cylinder
iso4796_bottle(b, thread=true);     // with the GL45 thread (needs din168-thread-scad)
iso4796_bottle(b, angle=270);       // cut away
iso4796_volume_below(b, 100);       // mL held when filled to 100 mm
iso4796_report(b);                  // echo the capacity against what the standard asks
```

- **Sizes:** every size in ISO 4796-1:2016, 25 mL to 20 L (`iso4796_sizes`, in the standard's
  order). The table, the capacities and the 1:30 taper from 3.5 L are the standard's; every figure
  is recorded with its source in [docs/references.md](docs/references.md).
- **Neck:** the standard leaves the thread to DIN 168 and does not name one. The finish per size is
  what DURAN puts on it: GL25 at 25 mL, GL32 at 50 mL, GL45 from 100 mL. The bores (14.3, 17, 30 mm)
  are published figures, not the standard's minima.
- **Thread:** off by default, so the library needs nothing else. The thread band is then drawn at
  the thread's outside diameter, which is its envelope. `thread=true` draws the DIN 168 profile from
  [din168-thread-scad](https://github.com/CameronBrooks11/din168-thread-scad), which must then be on
  `OPENSCADPATH`. Without it OpenSCAD prints one `Can't open library` warning, and a `thread=true`
  call stops with an assertion naming the library.
- **What is chosen, not sourced:** the base and shoulder radii, the base thickness, and the neck's
  lengths. Each is a named variable marked CHOICE in `iso4796.scad`. The cone is not chosen: it is
  whatever fits between the shoulder and the neck.
- **Capacity:** `iso4796_report()` compares what the drawn bottle holds with the standard's
  capacities. From 3.5 L up it is within 5 %; from 25 mL to 2 L it holds 11-45 % too much, for
  reasons in [docs/references.md](docs/references.md#findings). Treat small bottles' capacities as
  unverified until a measured bottle corrects the choices.

## Sizes

`iso4796_by_capacity(ml)` returns a size. Heights and diameters in mm, approximate as the standard
gives them.

| mL     | h1  | h2  | d1  | s min | d2 min | Finish |
| ------ | --- | --- | --- | ----- | ------ | ------ |
| 25     | 70  | 41  | 36  | 1.0   | 12.5   | GL25   |
| 50     | 87  | 50  | 46  | 1.0   | 15     | GL32   |
| 100    | 100 | 60  | 56  | 1.5   | 27     | GL45   |
| 150    | 110 | 70  | 62  | 1.5   | 27     | GL45   |
| 250    | 138 | 90  | 70  | 1.5   | 27     | GL45   |
| 500    | 176 | 110 | 86  | 1.5   | 27     | GL45   |
| 750    | 204 | 133 | 95  | 1.7   | 27     | GL45   |
| 1 000  | 225 | 153 | 101 | 1.7   | 27     | GL45   |
| 2 000  | 260 | 170 | 136 | 2.0   | 27     | GL45   |
| 3 500  | 295 | 184 | 161 | 2.0   | 27     | GL45   |
| 5 000  | 330 | 208 | 181 | 2.0   | 27     | GL45   |
| 10 000 | 410 | 265 | 227 | 2.7   | 27     | GL45   |
| 15 000 | 445 | 285 | 268 | 2.7   | 27     | GL45   |
| 20 000 | 505 | 330 | 288 | 3.0   | 27     | GL45   |

## Examples

- [examples/all_sizes.scad](examples/all_sizes.scad): every size in a row, labelled, with each
  capacity report echoed.
- [examples/500ml_section.scad](examples/500ml_section.scad): a 500 mL bottle cut away, thread drawn.

## Maker-specific bottles

A size is a row, `[name, capacity, h1, h2, d1, s, d2, finish]`. A maker's bottle is the same row
with its maker's numbers, in a file per maker, and every function here reads it:

```openscad
use <iso4796-bottle-scad/iso4796.scad>
use <iso4796-bottle-scad/duran.scad>
use <iso4796-bottle-scad/kimax.scad>

iso4796_bottle(duran_by_capacity(3500));   // DURAN 21 801 69 08: 160 across, where ISO says 161
iso4796_report(duran_by_capacity(1000));   // also sets the drawn bottle against DWK's brim capacity
iso4796_bottle(kimax_by_capacity(500));    // KIMAX 14396-500
```

- **[duran.scad](duran.scad):** DURAN Original, 25 mL to 20 L, named by catalogue number. Height and
  diameter from DWK's order sheet, which differs from the standard in three places (750 mL, 3.5 L,
  5 L); brim capacity where DWK publishes one, carried as a ninth field.
- **[kimax.scad](kimax.scad):** KIMBLE KIMAX GL45 media bottles, 100 mL to 10 L, catalogue 14396.
  Height and diameter as DWK lists them, all equal to the standard's.

Neither maker publishes the height to the shoulder, the wall or the neck, so their rows take the
standard's. Rows for other makers, and for generic Boro 3.3 bottles, are tracked in the issues.
