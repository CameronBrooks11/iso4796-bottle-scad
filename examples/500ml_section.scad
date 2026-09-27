// A 500 mL bottle cut away to show its section.
use <../iso4796.scad>

// Draw the GL45 thread. Needs din168-thread-scad on OPENSCADPATH; a full render then takes under a
// minute on OpenSCAD 2021.01. Off, the thread band is a plain cylinder at the thread's diameter.
thread = false;

iso4796_bottle(iso4796_by_capacity(500), thread=thread, angle=270, $fn=96);
