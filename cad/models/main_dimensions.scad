use <MCAD/metric_fastners.scad>


tolerance = 0.2;

shaft_radius = 6 / 2 + tolerance / 2;
mount_hole_radius = 3 / 2 + tolerance / 2;

total_width = 67;

hub_outer_radius = 25.4 / 2 + tolerance / 2;
hub_height = 5;

axial_bearing_radius = 26 / 2 + tolerance / 2;

cylinder_length = 38;
cylinder_wall_thick = 7;
cylinder_radius = hub_outer_radius + cylinder_wall_thick;

mount_hole_z = 5;

motor_holder_width = 50;
motor_holder_thick = 4;
motor_shaft_to_top = 70;
motor_shaft_shift = motor_holder_width / 2 - 17.86;
motor_holder_mounting_hole_shift = hub_outer_radius + (cylinder_radius - hub_outer_radius) / 2;

bottom_plate_base_height = 3;


module mounting_hole(thickness, use_bolt)
{
    d = 3 + tolerance;
    l = 10;
    
    if(use_bolt)
    {
        csk_bolt(d, l);
    }
    else
    {
        cylinder(h = l, r = d / 2);
    }
    rotate([180, 0, 0]) translate([0, 0, -0.05]) cylinder(h = l, r = 1.2 * d);
    translate([0, 0, thickness + 0.2]) cylinder(h = l, r = 1.2 * d);
}
