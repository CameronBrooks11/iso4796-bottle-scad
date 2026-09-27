// A 500 mL bottle cut away to show its section, with the GL45 thread drawn. Needs
// din168-thread-scad on OPENSCADPATH; a full render takes under a minute on OpenSCAD 2021.01.
use <../iso4796.scad>

iso4796_bottle(iso4796_by_capacity(500), thread=true, angle=270, $fn=96);
