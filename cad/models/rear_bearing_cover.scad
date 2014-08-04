include <main_dimensions.scad>
use <wheel_holder.scad>


$fn=64;

module rear_bearing_cover()
{
    shaft_hole_h = 15;
    front_cylinder_x = -(75 + rear_bearing_hole_w);

    difference()
    {
        hull()
        {
            cylinder(h = rear_cover_h, r = wheel_holder_r);
            translate([front_cylinder_x, 0, 0])
            cylinder(h = rear_cover_h, r = wheel_holder_r / 3);
        }

        // Shaft hole
        hull()
        {
            cylinder(h = rear_cover_h, r = shaft_hole_h / 2);
            translate([-2 * rear_bearing_hole_w, 0, 0])
            cylinder(h = rear_cover_h, r = shaft_hole_h / 2);
        }

        // Front mounting hole
        translate([front_cylinder_x, 0, rear_cover_h - 1])
        rotate([180, 0, 0]) mounting_hole(rear_cover_h * 1.3, false);

        rotate([0, 0, 45])
        translate([wheel_holder_r - 4.5, 0, rear_cover_h - 1])
        rotate([180, 0, 0]) mounting_hole(rear_cover_h, false);

        rotate([0, 0, -45])
        translate([wheel_holder_r - 4.5, 0, rear_cover_h - 1])
        rotate([180, 0, 0]) mounting_hole(rear_cover_h, false);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    rear_bearing_cover();
}
