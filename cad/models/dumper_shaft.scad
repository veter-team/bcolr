use <holder-to-shaft-coupling.scad>
include <main_dimensions.scad>

$fn=64;

module dumper_shaft()
{
    difference()
    {
        rotate([90, 0, 0])
        translate([motor_holder_mounting_hole_shift,
                cylinder_length - mount_hole_z,
                -total_width / 2 + 1])
        difference()
        {
            cylinder(h = total_width / 2, r = 4);
            cylinder(h = total_width / 2, r = mount_hole_radius + tolerance);
            difference()
            {
                translate([0, 0, 10]) cylinder(h = 5, r = 5);

                // For small dumper
                //translate([0, 0, 10]) cylinder(h = 5, r = 2.5);

                // For large dumper
                translate([0, 0, 10]) cylinder(h = 5, r = 3.25);
            }
        }
        translate([motor_holder_mounting_hole_shift,
                0,
                cylinder_length - mount_hole_z])
        cube([10, 16, 10], center = true);

        translate([motor_holder_mounting_hole_shift,
                37,
                cylinder_length - mount_hole_z])
        cube([10, 16, 10], center = true);
        
        whole_part();
    }
}


module dumper_shaft_inner()
{
    difference()
    {
        translate([-motor_holder_mounting_hole_shift,
                -cylinder_length + mount_hole_z,
                total_width / 2 - 1 - 15])
        rotate([-90, 0, 0])
        dumper_shaft();

        translate([0, 0, -25]) cube([20, 20, 50], center = true);
    }
}


module dumper_shaft_middle()
{
    difference()
    {
        translate([-motor_holder_mounting_hole_shift,
                -cylinder_length + mount_hole_z,
                total_width / 2 - 1 - 10])
        rotate([-90, 0, 0])
        dumper_shaft();

        translate([0, 0, -25]) cube([20, 20, 50], center = true);
        translate([0, 0, 29.99]) cube([20, 20, 50], center = true);
    }
}


module dumper_shaft_outer()
{
    difference()
    {
        translate([0, 0, 10])
        rotate([180, 0, 0])
        translate([-motor_holder_mounting_hole_shift,
                -cylinder_length + mount_hole_z,
                total_width / 2 - 1])
        rotate([-90, 0, 0])
        dumper_shaft();

        translate([0, 0, -25]) cube([20, 20, 50], center = true);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //dumper_shaft_inner();
    dumper_shaft_middle();
    //dumper_shaft_outer();
    
    //dumper_shaft();
}
