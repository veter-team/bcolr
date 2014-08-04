include <main_dimensions.scad>
use <MCAD/boxes.scad>

$fn=64;

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
            cylinder(h = wheel_holder_thick, r = wheel_holder_r);
            translate([main_hole_dist + rear_bearing_hole_w, 0, 0])
            cylinder(h = wheel_holder_thick, r = wheel_holder_r);
        }

        // Rear mounting hole top
        translate([main_hole_dist + rear_bearing_hole_w, 0, 0])
        rotate([0, 0, 45])
        translate([wheel_holder_r - 4.5, 0, wheel_holder_thick + tolerance])
        rotate([180, 0, 0])
        mounting_hole(wheel_holder_thick + tolerance, false);

        // Rear mounting hole bottom
        translate([main_hole_dist + rear_bearing_hole_w, 0, 0])
        rotate([0, 0, -45])
        translate([wheel_holder_r - 4.5, 0, wheel_holder_thick + tolerance])
        rotate([180, 0, 0])
        mounting_hole(wheel_holder_thick + tolerance, false);

        // Front mounting holes
        for(a = [0 : 360 / 3 : 360])
        {
            rotate([0, 0, a + 180])
            translate([wheel_holder_r - (wheel_holder_r - front_bearing_hole_r) / 2, 0, -2])
            mounting_hole(wheel_holder_thick, false);
        }
        
        // Front bearing hole
        translate([0, 0, 1]) cylinder(h = wheel_holder_thick, r = front_bearing_hole_r);
        cylinder(h = wheel_holder_thick, r = front_bearing_hole_r - 3);

        // Rear bearing hole
        translate([main_hole_dist, 0, 0]) rear_bearing_hole();
        translate([main_hole_dist - 2 * (rear_bearing_hole_r + rear_bearing_hole_w) - 25 / 2 - 4, -5 / 2, 0])
        cube([25, 5, wheel_holder_thick], center = false);

        // Mounting holes for horizontal middle plate
        translate([main_hole_dist - 75, 0, -tolerance]) mounting_hole(wheel_holder_thick * 1.3, false);
        translate([main_hole_dist - 75 - 35, 0, -tolerance]) mounting_hole(wheel_holder_thick * 1.3, false);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    wheel_holder_base();
    //rear_bearing_hole();
}
