include <main_dimensions.scad>
use <wheel_holder.scad>
use <MCAD/boxes.scad>

//$fn=64;

module pusher()
{
    difference()
    {
        scale([1.0, 0.95, 1.0]) rear_bearing_hole();
        translate([ -rear_bearing_hole_w, 0, 0]) cylinder(h = wheel_holder_thick, r = rear_bearing_hole_r);

        translate([-rear_bearing_hole_w * 2, -rear_bearing_hole_r, 0])
        cube([30, rear_bearing_hole_r * 2, wheel_holder_thick]);
    }

    translate([-rear_bearing_hole_r * 2 - rear_bearing_hole_w - 10 + 4, 0, wheel_holder_thick / 2])
    roundedBox([rear_bearing_hole_r + rear_bearing_hole_w + 5, 5 - tolerance, wheel_holder_thick],
        2, true);
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    pusher();
}
