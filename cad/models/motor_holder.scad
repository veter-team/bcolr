include <main_dimensions.scad>

$fn=64;


module large_bearing_spacer()
{
    difference()
    {
        union()
        {
            cylinder(h = motor_holder_thick / 2, r = motor_holder_width / 2);
            translate([0, -motor_shaft_shift, motor_holder_thick / 2])
            {
                cylinder(h = 1, r = 8.60);
                cylinder(h = 8, r = 7.60);
            }
        }
        translate([0, -motor_shaft_shift, 0])
        cylinder(motor_holder_thick / 2 + 8, r = 3.5);
    }
}


module motor_mount_hole()
{
    rad = 1.59;

    hull()
    {
        translate([-2.44/2, 0, 0])
        cylinder(h = motor_holder_thick, r = rad);
        translate([2.44/2, 0, 0])
        cylinder(h = motor_holder_thick, r = rad);
    }
}


module holder_base()
{
    difference()
    {
        union()
        {
            translate([-motor_holder_width / 2, 0, 0])
            cube(size = [motor_holder_width, motor_shaft_to_top - motor_shaft_shift, motor_holder_thick]);
    
            cylinder(h = motor_holder_thick, r = motor_holder_width / 2);

            translate([0, 0, motor_holder_thick]) large_bearing_spacer();

            // Anti-rotate mounting pad (for fixed wheel)
            hull()
            {
                translate([0, motor_shaft_to_top - motor_shaft_shift, mount_hole_radius * 4])
                rotate([90, 0, 0])
                cylinder(h = mount_hole_z, r = mount_hole_radius * 4);
                
                translate([0,
                        motor_shaft_to_top - motor_shaft_shift - mount_hole_z / 2,
                        motor_holder_thick - tolerance])
                cube(size = [motor_holder_width * 0.45, mount_hole_z, tolerance], center = true);
            }
        }

        // Round hole in the mounting area (to save filament and printing time)
        translate([0, motor_shaft_to_top - motor_shaft_shift - motor_holder_width / 4 - mount_hole_z - 1, 0])
        cylinder(h = motor_holder_thick, r = motor_holder_width / 4);
        
        // Hole for motor shaft
        translate([0, -motor_shaft_shift, 0])
        cylinder(h = motor_holder_thick, r = 6.4);

        // Motor mounting holes
        translate([14.2, 0, 0]) motor_mount_hole();
        mirror([1,0,0]) translate([14.2, 0, 0]) motor_mount_hole();

        // Larger motor mouning holes in large bearing spacer
        translate([0, 0, motor_holder_thick])
        {
            translate([14.2, 0, 0]) scale([2.5, 2.5]) motor_mount_hole();
            mirror([1,0,0]) translate([14.2, 0, 0]) scale([2.5, 2.5]) motor_mount_hole();
        }

        // Mounting holes
        translate([motor_holder_mounting_hole_shift,
                motor_shaft_to_top - motor_shaft_shift - mount_hole_z,
                -0.1])
        mounting_hole(motor_holder_thick * 1.3, false);

        translate([-motor_holder_mounting_hole_shift,
                motor_shaft_to_top - motor_shaft_shift - mount_hole_z,
                -0.1])
        mounting_hole(motor_holder_thick * 1.3, false);
        
        translate([-motor_holder_mounting_hole_shift,
                motor_shaft_to_top - motor_shaft_shift - cylinder_length + mount_hole_z,
                -0.1])
        mounting_hole(motor_holder_thick * 1.3, false);

        translate([motor_holder_mounting_hole_shift,
                motor_shaft_to_top - motor_shaft_shift - cylinder_length + mount_hole_z,
                -0.1])
        mounting_hole(motor_holder_thick * 1.3, false);

        // Holes for horizontal bulk to prevent holder bending
        translate([-motor_holder_width / 2 + mount_hole_z * 2,
                16,
                -0.1])
        mounting_hole(motor_holder_thick * 2, false);
        translate([motor_holder_width / 2 - mount_hole_z * 2,
                16,
                -0.1])
        mounting_hole(motor_holder_thick * 2, false);

        // Anti-rotation pad mounting hole
        translate([0,
                motor_shaft_to_top - motor_shaft_shift - mount_hole_z - tolerance,
                mount_hole_radius * 5])
        rotate([270, 0, 0])
        mounting_hole(mount_hole_z * 1.3, true);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    holder_base();
}
