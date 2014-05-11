include <main_dimensions.scad>

//$fn=64;


module bottom_plate()
{
    plate_base_radius = cylinder_radius * 1.2;
    shaft_len = 3;
    
    difference()
    {
        union()
        {
            difference()
            {
                // Main plate
                cylinder(h = bottom_plate_base_height, r = plate_base_radius);

                // Pocket for bearing
                translate([0, 0, bottom_plate_base_height - 1])
                cylinder(h = 1, r = axial_bearing_radius);
            }
            // Shaft for bearing
            translate([0, 0, bottom_plate_base_height - 1])
            cylinder(h = shaft_len - tolerance, r = 13 / 2 - tolerance / 2);
        }
        // Hole for the shaft
        cylinder(h = bottom_plate_base_height + shaft_len, r = shaft_radius + tolerance);

        for(i = [0 : 360 / 3 : 360])
        {
            rotate([180, 0, i])
            translate([axial_bearing_radius + (plate_base_radius - axial_bearing_radius) / 2,
                    0,
                    -bottom_plate_base_height-0.1])
            mounting_hole(bottom_plate_base_height * 1.3, true);
        }
        
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    bottom_plate();
}