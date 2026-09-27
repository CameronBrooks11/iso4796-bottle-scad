/**
 * @file kimax.scad
 * @brief KIMBLE KIMAX GL45 media bottles (DWK Life Sciences), as rows iso4796.scad draws
 *
 * `use <iso4796-bottle-scad/kimax.scad>` beside iso4796.scad, then e.g.
 * `iso4796_bottle(kimax_by_capacity(500))`. Draws nothing at top level.
 *
 * Height and outside diameter are DWK's (docs/references.md). DWK publishes no height to the
 * shoulder, wall or brim capacity, so each row takes the ISO 4796-1 size's where it can and has no
 * brim. The 30 mm opening DWK gives is the GL45 bore the ISO rows already carry.
 */

use <iso4796.scad>

// A row: nominal mL, then h and d in mm, named by the catalogue number without cap (14396-); the
// capped bottle, 14395-, is the same glass at the same height.
function _kimax(ml, h, d) =
  let (iso = iso4796_by_capacity(ml))
  [
    str("KIMAX 14396-", ml), ml, h, iso4796_shoulder_height(iso), d, iso4796_wall(iso),
    iso4796_neck_diameter_min(iso), iso4796_finish(iso),
  ];

kimax_100 = _kimax(100, 100, 56);
kimax_250 = _kimax(250, 138, 70);
kimax_500 = _kimax(500, 176, 86);
kimax_1000 = _kimax(1000, 225, 101);
kimax_2000 = _kimax(2000, 260, 136);
kimax_5000 = _kimax(5000, 330, 181);
kimax_10000 = _kimax(10000, 410, 227);

kimax_bottles = [kimax_100, kimax_250, kimax_500, kimax_1000, kimax_2000, kimax_5000, kimax_10000];

// A KIMAX bottle by nominal capacity in mL, e.g. 500.
function kimax_by_capacity(ml) =
  let (found = [for (s = kimax_bottles) if (s[1] == ml) s])
  assert(len(found) > 0, str("kimax_by_capacity: no KIMAX GL45 media bottle of ", ml, " mL"))
  found[0];
