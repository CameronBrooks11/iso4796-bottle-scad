/**
 * @file duran.scad
 * @brief DURAN Original GL laboratory bottles (DWK Life Sciences), as rows iso4796.scad draws
 *
 * `use <iso4796-bottle-scad/duran.scad>` beside iso4796.scad, then e.g.
 * `iso4796_bottle(duran_by_capacity(500))`. Draws nothing at top level.
 *
 * Height, diameter and brim capacity are DWK's (docs/references.md). DWK publishes no height to
 * the shoulder, wall or neck bore, so each row takes the ISO 4796-1 size's, and the finish DWK
 * lists is the one the ISO rows already carry.
 */

use <iso4796.scad>

// A row: the glass's catalogue number (without cap and pouring ring), nominal mL, h and d in mm,
// then brim in mL, undef where DWK gives none.
function _duran(cat, ml, h, d, brim) =
  let (iso = iso4796_by_capacity(ml))
  [
    str("DURAN ", cat), ml, h, iso4796_shoulder_height(iso), d, iso4796_wall(iso),
    iso4796_neck_diameter_min(iso), iso4796_finish(iso), brim,
  ];

duran_25 = _duran("21 801 14 04", 25, 70, 36, 34);
duran_50 = _duran("21 801 17 04", 50, 87, 46, 70);
duran_100 = _duran("21 801 24 09", 100, 100, 56, 138);
duran_150 = _duran("21 801 29 06", 150, 110, 62, 190);
duran_250 = _duran("21 801 36 02", 250, 138, 70, 310);
duran_500 = _duran("21 801 44 01", 500, 176, 86, 619);
duran_750 = _duran("21 801 51 06", 750, 203, 95, undef);
duran_1000 = _duran("21 801 54 06", 1000, 225, 101, 1150);
duran_2000 = _duran("21 801 63 08", 2000, 260, 136, 2265);
duran_3500 = _duran("21 801 69 08", 3500, 295, 160, 3980);
duran_5000 = _duran("21 801 73 04", 5000, 330, 182, 5950);
duran_10000 = _duran("21 801 86 09", 10000, 410, 227, 11220);
duran_15000 = _duran("21 801 88 06", 15000, 445, 268, undef);
duran_20000 = _duran("21 801 91 08", 20000, 505, 288, undef);

duran_bottles = [
  duran_25, duran_50, duran_100, duran_150, duran_250, duran_500, duran_750, duran_1000, duran_2000,
  duran_3500, duran_5000, duran_10000, duran_15000, duran_20000,
];

// A DURAN bottle by nominal capacity in mL, e.g. 500.
function duran_by_capacity(ml) =
  let (found = [for (s = duran_bottles) if (s[1] == ml) s])
  assert(len(found) > 0, str("duran_by_capacity: no DURAN Original bottle of ", ml, " mL"))
  found[0];
