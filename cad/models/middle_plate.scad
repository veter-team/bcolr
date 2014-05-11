use <MCAD/boxes.scad>
include <main_dimensions.scad>

$fn=64;

module shaft_hole(w, h, wall)
{
    translate([0, h / 2 - wall - mount_hole_radius, 0])
    rotate([0, 90, 0])
    cylinder(h = w + tolerance, r = mount_hole_radius, center=true);
}

module mount_pocket(w, h, d, hole_depth, distance_from_side)
{
    translate([w / 2 - distance_from_side, h / 2 - hole_depth / 2 + 2, 0])
    roundedBox([6, hole_depth, d+0.1], 2, true);
}


module middle_plate()
{
    w = 80;
    h = 45;
    wall = 3;
    d = mount_hole_radius * 2 + wall * 2;
    hole_depth = 15;

    difference()
    {
        roundedBox([w, h, d], 1, false);

        shaft_hole(w, h, wall);
        // second
        mirror([0, 1, 0])
        shaft_hole(w, h, wall);

        // For dumpers
        mount_pocket(w, h, d, hole_depth, 19);
        // second
        mirror([1, 0, 0])
        mount_pocket(w, h, d, hole_depth, 19);

        // For screws
        mirror([0, 1, 0])
        mount_pocket(w, h, d, hole_depth, 6);
        // second
        mirror([0, 1, 0])
        mirror([1, 0, 0])
        mount_pocket(w, h, d, hole_depth, 6);

        // Large hole on the screw side
        translate([0, -h / 2 - 2, 0])
        cube([w - 6 * 2, hole_depth * 2, d+0.1], center = true);

        // Large hole in the middle
        translate([0, 3, 0])
        roundedBox([w * 0.3, h * 0.2, d+0.1], 3, true);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    middle_plate();
}
