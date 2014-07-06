include <main_dimensions.scad>
use <MCAD/boxes.scad>

//$fn=64;

module rear_bearing_hole()
{
    hull()
    {
        //translate([-rear_bearing_hole_w, 0, 0]) cylinder(h = wheel_holder_thick, r = rear_bearing_hole_r);
        translate([-rear_bearing_hole_r - rear_bearing_hole_w, 0, wheel_holder_thick / 2])
        roundedBox([rear_bearing_hole_r + rear_bearing_hole_w, rear_bearing_hole_r * 2, wheel_holder_thick],
            2, true);
        translate([ rear_bearing_hole_w, 0, 0]) cylinder(h = wheel_holder_thick, r = rear_bearing_hole_r);
    }
}


module wheel_holder_base()
{
    difference()
    {
        // Base
        hull()
        {
            cylinder(h = wheel_holder_thick, r = 20);
            translate([main_hole_dist + rear_bearing_hole_w, 0, 0]) cylinder(h = wheel_holder_thick, r = 20);
        }

        // Front bearing hole
        cylinder(h = wheel_holder_thick, r = 12.10);
        
        translate([main_hole_dist, 0, 0]) rear_bearing_hole();

        translate([main_hole_dist - 2 * (rear_bearing_hole_r + rear_bearing_hole_w) - 25 / 2 - 4, -5 / 2, 0])
        cube([25, 5, wheel_holder_thick], center = false);

        translate([main_hole_dist - 75, 0, -tolerance]) mounting_hole(wheel_holder_thick * 1.3, false);
        translate([main_hole_dist - 75 - 35, 0, -tolerance]) mounting_hole(wheel_holder_thick * 1.3, false);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    wheel_holder_base();
    //rear_bearing_hole();
}
