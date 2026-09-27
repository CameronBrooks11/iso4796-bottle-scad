/**
 * @file iso4796.scad
 * @brief ISO 4796-1 screw-neck laboratory bottles: size table, section, capacity and a drawing
 *
 * `use <iso4796-bottle-scad/iso4796.scad>`. Draws nothing at top level; see examples/.
 *
 * Every dimension in the table below is from ISO 4796-1:2016 as recorded in docs/references.md.
 * The standard fixes the envelope and the capacities; it leaves the corners, the cone and the neck
 * to the maker. Those are marked CHOICE where they are made, and the capacity report says how far
 * the result sits from what the standard asks of it.
 *
 * The thread is optional and off by default. Drawn, it comes from din168-thread-scad, which is
 * then needed on OPENSCADPATH; without it OpenSCAD warns once that it cannot open the library and
 * everything but the thread still works.
 */

use <din168-thread-scad/din168.scad>

// ----- neck finishes -----

// ISO 4796-1 does not say which thread a bottle carries (5.2.6 leaves it to national standards).
// These are the DIN 168 threads the makers put on each size, and the glass bore inside them.
// [GL name, thread d, thread core d1, pitch P, bore]. d, d1 and P restate DIN 168-1 Tabelle 1 so the
// neck can be drawn without din168-thread-scad; iso4796_bottle() checks them against it when it
// draws the thread. Bores: docs/references.md.
iso4796_gl25 = ["GL25", 25, 22.98, 3, 14.3];
iso4796_gl32 = ["GL32", 32, 29.30, 4, 17];
iso4796_gl45 = ["GL45", 45, 42.30, 4, 30];

function iso4796_finish_name(finish) = finish[0];
function iso4796_finish_thread_diameter(finish) = finish[1];
function iso4796_finish_core_diameter(finish) = finish[2];
function iso4796_finish_pitch(finish) = finish[3];
function iso4796_finish_bore(finish) = finish[4];

// ----- size table (ISO 4796-1:2016, Table 1; docs/references.md) -----

// [name, nominal capacity mL, h1, h2, d1, s, d2, finish]: the standard's columns as it gives them,
// then the finish. h1 total height, h2 height to the shoulder, d1 outside diameter (all approx.),
// s wall thickness (min.), d2 internal neck diameter (min.). mm.
iso4796_25 = ["ISO 4796-1 - 25", 25, 70, 41, 36, 1.0, 12.5, iso4796_gl25];
iso4796_50 = ["ISO 4796-1 - 50", 50, 87, 50, 46, 1.0, 15, iso4796_gl32];
iso4796_100 = ["ISO 4796-1 - 100", 100, 100, 60, 56, 1.5, 27, iso4796_gl45];
iso4796_150 = ["ISO 4796-1 - 150", 150, 110, 70, 62, 1.5, 27, iso4796_gl45];
iso4796_250 = ["ISO 4796-1 - 250", 250, 138, 90, 70, 1.5, 27, iso4796_gl45];
iso4796_500 = ["ISO 4796-1 - 500", 500, 176, 110, 86, 1.5, 27, iso4796_gl45];
iso4796_750 = ["ISO 4796-1 - 750", 750, 204, 133, 95, 1.7, 27, iso4796_gl45];
iso4796_1000 = ["ISO 4796-1 - 1000", 1000, 225, 153, 101, 1.7, 27, iso4796_gl45];
iso4796_2000 = ["ISO 4796-1 - 2000", 2000, 260, 170, 136, 2.0, 27, iso4796_gl45];
iso4796_3500 = ["ISO 4796-1 - 3500", 3500, 295, 184, 161, 2.0, 27, iso4796_gl45];
iso4796_5000 = ["ISO 4796-1 - 5000", 5000, 330, 208, 181, 2.0, 27, iso4796_gl45];
iso4796_10000 = ["ISO 4796-1 - 10000", 10000, 410, 265, 227, 2.7, 27, iso4796_gl45];
iso4796_15000 = ["ISO 4796-1 - 15000", 15000, 445, 285, 268, 2.7, 27, iso4796_gl45];
iso4796_20000 = ["ISO 4796-1 - 20000", 20000, 505, 330, 288, 3.0, 27, iso4796_gl45];

// In the standard's order (3.1).
iso4796_sizes = [
  iso4796_25, iso4796_50, iso4796_100, iso4796_150, iso4796_250, iso4796_500, iso4796_750,
  iso4796_1000, iso4796_2000, iso4796_3500, iso4796_5000, iso4796_10000, iso4796_15000, iso4796_20000,
];

// A size by nominal capacity in mL, e.g. 500.
function iso4796_by_capacity(ml) =
  let (found = [for (s = iso4796_sizes) if (s[1] == ml) s])
  assert(len(found) > 0, str("iso4796_by_capacity: no ISO 4796-1 bottle of ", ml, " mL"))
  found[0];

function iso4796_name(size) = size[0];
function iso4796_capacity(size) = size[1]; // nominal, mL: filled to the turn of the shoulder (3.2)
function iso4796_height(size) = size[2]; // h1
function iso4796_shoulder_height(size) = size[3]; // h2
function iso4796_diameter(size) = size[4]; // d1
function iso4796_wall(size) = size[5]; // s
function iso4796_neck_diameter_min(size) = size[6]; // d2
function iso4796_finish(size) = size[7];

// 5.2.2: cylindrical to 2 L, tapered 1:30 from 3.5 L, narrower at the base.
function iso4796_tapered(size) = iso4796_capacity(size) >= 3500;

// ----- the section's choices -----

// Base thickness, as a multiple of the wall. CHOICE: the standard gives s only as a minimum.
iso4796_base_factor = 2;
// Base corner radius, outside, as a fraction of d1. CHOICE: 5.2.2 asks only for "a suitable
// radius"; this is about what Figure 1 draws.
iso4796_base_radius_ratio = 0.1;
// Shoulder radius, outside, as a fraction of d1. CHOICE, likewise (5.2.3).
iso4796_shoulder_radius_ratio = 0.15;
// The neck, in pitches of its thread: a plain band above the cone, the thread, and a lip above it.
// CHOICE: no source found gives a neck's lengths.
iso4796_neck_band_pitches = 2;
iso4796_thread_pitches = 3;
iso4796_lip_pitches = 0.5;
// 3.3: the capacity to the base of the neck is about this much of the nominal.
iso4796_neck_capacity_ratio = 1.15;

function iso4796_base_thickness(size) = iso4796_base_factor * iso4796_wall(size);
function iso4796_base_radius(size) = iso4796_base_radius_ratio * iso4796_diameter(size);
function iso4796_shoulder_radius(size) = iso4796_shoulder_radius_ratio * iso4796_diameter(size);
// 5.2.4: "as small as possible"; one wall is the smallest that keeps the inside's corner real.
function iso4796_neck_root_radius(size) = max(1, iso4796_wall(size));

function iso4796_neck_height(size) =
  (iso4796_neck_band_pitches + iso4796_thread_pitches + iso4796_lip_pitches)
  * iso4796_finish_pitch(iso4796_finish(size));
function iso4796_thread_length(size) = iso4796_thread_pitches * iso4796_finish_pitch(iso4796_finish(size));
// z of the neck's base (the top of the cone) and of the thread's lower end.
function iso4796_neck_base_z(size) = iso4796_height(size) - iso4796_neck_height(size);
function iso4796_thread_z(size) =
  iso4796_neck_base_z(size) + iso4796_neck_band_pitches * iso4796_finish_pitch(iso4796_finish(size));

// The body's outside radius at z. CHOICE: d1 is the diameter at the shoulder, and a tapered body
// narrows from there to the base; Figure 2 does not say where d1 is taken.
function iso4796_body_radius(size, z) =
  iso4796_diameter(size) / 2
  - (iso4796_tapered(size) ? (iso4796_shoulder_height(size) - z) / 30 / 2 : 0);

// ----- the cone -----

// The cone's slope from horizontal, in degrees. The standard fixes the heights and diameters at
// both ends of it and the radii are chosen, so the slope is what fits: the angle at which a line
// tangent to the shoulder arc is also tangent to the neck's root. Bisected, since both tangent
// points move with it.
function iso4796_cone_slope(size) =
  let (
    f = function(b) let (s = _iso4796_shoulder_tangent(size, b), n = _iso4796_root_tangent(size, b))
      atan2(n[1] - s[1], s[0] - n[0]) - b
  )
  assert(f(1) * f(89) < 0, str(iso4796_name(size), ": no cone fits between the shoulder and the neck"))
  _iso4796_bisect(f, 1, 89, 40);

function _iso4796_bisect(f, lo, hi, n) =
  let (m = (lo + hi) / 2)
  n == 0 ? m : f(lo) * f(m) <= 0 ? _iso4796_bisect(f, lo, m, n - 1) : _iso4796_bisect(f, m, hi, n - 1);

// Centres of the two convex corners and the one concave, outside and inside alike.
function _iso4796_shoulder_centre(size) =
  [iso4796_diameter(size) / 2 - iso4796_shoulder_radius(size), iso4796_shoulder_height(size)];
function _iso4796_root_centre(size) =
  [
    iso4796_finish_core_diameter(iso4796_finish(size)) / 2 + iso4796_neck_root_radius(size),
    iso4796_neck_base_z(size),
  ];

// Where a cone of slope b leaves the shoulder arc and meets the root arc, outside.
function _iso4796_shoulder_tangent(size, b) =
  _iso4796_shoulder_centre(size) + iso4796_shoulder_radius(size) * [sin(b), cos(b)];
function _iso4796_root_tangent(size, b) =
  _iso4796_root_centre(size) + iso4796_neck_root_radius(size) * [-sin(b), -cos(b)];

// ----- the section -----
//
// Upright: x is radius, y is height above the base. Arcs are listed as points; straight runs are
// implicit between them. `n` is segments per arc.

function _iso4796_arc(c, r, a0, a1, n) =
  [for (i = [0:n]) let (a = a0 + (a1 - a0) * i / n) c + r * [cos(a), sin(a)]];

// The outside, from the axis under the base to the rim's outer edge. The thread band is drawn at
// the thread's full diameter: an envelope. With the thread drawn, the neck stays at the core.
function iso4796_outer_profile(size, thread_envelope = true, n = 16) =
  let (
    b = iso4796_cone_slope(size),
    rb = iso4796_base_radius(size),
    x_base = iso4796_body_radius(size, 0),
    f = iso4796_finish(size),
    r_core = iso4796_finish_core_diameter(f) / 2,
    r_thread = thread_envelope ? iso4796_finish_thread_diameter(f) / 2 : r_core,
    z_t = iso4796_thread_z(size),
    z_t1 = z_t + iso4796_thread_length(size)
  )
    concat(
      [[0, 0]],
      _iso4796_arc([x_base - rb, rb], rb, 270, 360, n),
      _iso4796_arc(_iso4796_shoulder_centre(size), iso4796_shoulder_radius(size), 0, 90 - b, n),
      _iso4796_arc(_iso4796_root_centre(size), iso4796_neck_root_radius(size), 270 - b, 180, n),
      [[r_core, z_t], [r_thread, z_t], [r_thread, z_t1], [r_core, z_t1], [r_core, iso4796_height(size)]]
    );

// The inside, from the axis on the floor to the rim's inner edge: the outside's corners less the
// wall, then down the cone until it reaches the bore, and straight up the bore.
function iso4796_inner_profile(size, n = 16) =
  let (
    b = iso4796_cone_slope(size),
    t = iso4796_wall(size),
    tb = iso4796_base_thickness(size),
    rb = iso4796_base_radius(size),
    x_base = iso4796_body_radius(size, 0),
    r_bore = iso4796_finish_bore(iso4796_finish(size)) / 2,
    shoulder =
      _iso4796_arc(_iso4796_shoulder_centre(size), iso4796_shoulder_radius(size) - t, 0, 90 - b, n),
    s1 = shoulder[n],
    z_bore = s1[1] + (s1[0] - r_bore) * tan(b)
  )
    concat(
      [[0, tb]],
      _iso4796_arc([x_base - rb, tb + rb - t], rb - t, 270, 360, n),
      shoulder,
      [[r_bore, z_bore], [r_bore, iso4796_height(size)]]
    );

// The closed glass section: up the outside, across the rim, down the inside, home along the axis.
function iso4796_section(size, thread_envelope = true, n = 16) =
  let (i = iso4796_inner_profile(size, n))
    concat(iso4796_outer_profile(size, thread_envelope, n), [for (k = [len(i) - 1:-1:0]) i[k]]);

// ----- what it holds -----

// The inside below a height, with the crossing point interpolated in.
function _iso4796_below(p, z) =
  [
    for (i = [0:len(p) - 1])
      let (a = p[i], c = p[i + 1])
        each concat(
          a[1] <= z ? [a] : [],
          is_undef(c) || (a[1] - z) * (c[1] - z) >= 0
            ? []
            : [[a[0] + (c[0] - a[0]) * (z - a[1]) / (c[1] - a[1]), z]]
        )
  ];

// The volume a profile sweeps about the axis, mm3: pi/3 * dy * (r1^2 + r1 r2 + r2^2) per segment.
function _iso4796_swept(p) =
  len(p) < 2
    ? 0
    : let (
      terms = [
        for (i = [0:len(p) - 2])
          let (r1 = p[i][0], r2 = p[i + 1][0]) (p[i + 1][1] - p[i][1]) * (r1 * r1 + r1 * r2 + r2 * r2)
      ]
    )
      PI / 3 * (terms * [for (t = terms) 1]);

// mL held when filled to height z above the outside of the base. `n` is segments per arc of the
// inside's profile, finer than the drawing's by default because the capacity report reads it.
function iso4796_volume_below(size, z, n = 32) =
  _iso4796_swept(_iso4796_below(iso4796_inner_profile(size, n), z)) / 1000;

/**
 * Echo how the drawn bottle sits against what the standard asks of it: the capacity to the
 * shoulder against nominal (3.2), to the neck's base against 1.15 x nominal (3.3), and the cone
 * the fit found, against Figure 2's 90 degrees for the tapered sizes.
 */
module iso4796_report(size) {
  _nom = iso4796_capacity(size);
  _to_shoulder = iso4796_volume_below(size, iso4796_shoulder_height(size));
  _to_neck = iso4796_volume_below(size, iso4796_neck_base_z(size));
  _cone = 180 - 2 * iso4796_cone_slope(size);
  echo(str(
    iso4796_name(size), ": ",
    round(_to_shoulder), " mL to the shoulder (", round(100 * _to_shoulder / _nom), " % of nominal), ",
    round(_to_neck), " mL to the neck (", round(100 * _to_neck / _nom), " %, 3.3 asks about ",
    round(100 * iso4796_neck_capacity_ratio), "), ",
    "cone ", round(_cone), " deg included", iso4796_tapered(size) ? " (Figure 2: 90)" : ""
  ));
}

/**
 * The bottle, upright, base on z = 0.
 *
 * @param size    A size from iso4796_sizes, e.g. iso4796_by_capacity(500)
 * @param thread  Draw the DIN 168 thread. Needs din168-thread-scad; off, the thread band is a
 *                plain cylinder at the thread's diameter, which is its envelope
 * @param angle   Degrees of revolution; under 360 gives a cut-away
 * @param n       Segments per arc of the section
 */
module iso4796_bottle(size, thread = false, angle = 360, n = 16) {
  _f = iso4796_finish(size);
  _gl = thread ? din168_by_name(iso4796_finish_name(_f)) : undef;

  assert(
    !thread || !is_undef(_gl),
    "iso4796_bottle: thread=true needs din168-thread-scad on OPENSCADPATH"
  );
  assert(
    !thread
      || (din168_pitch(_gl) == iso4796_finish_pitch(_f)
        && din168_bolt_core(_gl)[1] == iso4796_finish_core_diameter(_f)),
    str("iso4796_bottle: ", iso4796_finish_name(_f), " here disagrees with din168-thread-scad")
  );
  assert(
    iso4796_finish_bore(_f) >= iso4796_neck_diameter_min(size),
    str(
      iso4796_name(size), ": a ", iso4796_finish_bore(_f), " bore is under the standard's d2 of ",
      iso4796_neck_diameter_min(size)
    )
  );

  rotate_extrude(angle=angle) polygon(iso4796_section(size, thread_envelope=!thread, n=n));

  if (thread)
    intersection() {
      translate([0, 0, iso4796_thread_z(size)])
        din168_bolt(_gl, iso4796_thread_length(size), bore=iso4796_finish_bore(_f), clearance=0);
      rotate_extrude(angle=angle) square([iso4796_diameter(size), iso4796_height(size)]);
    }
}
