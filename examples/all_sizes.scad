// Every ISO 4796-1 size in a row, labelled, thread off, with each size's capacity report echoed.
include <../iso4796.scad> // for iso4796_sizes; the library draws nothing at top level

gap = 20;

function r_at(i) = iso4796_diameter(iso4796_sizes[i]) / 2;

// x of each bottle's centre: the running sum of the diameters before it
function x_at(i) = i == 0 ? 0 : x_at(i - 1) + r_at(i - 1) + gap + r_at(i);

for (i = [0:len(iso4796_sizes) - 1]) {
  s = iso4796_sizes[i];
  iso4796_report(s);
  translate([x_at(i), 0, 0]) {
    iso4796_bottle(s);
    translate([0, -r_at(i) - 6, 0])
      linear_extrude(1)
        text(str(iso4796_capacity(s), " mL"), size=8, halign="center", valign="top");
  }
}
