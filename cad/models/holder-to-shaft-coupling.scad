use <MCAD/boxes.scad>
include <main_dimensions.scad>

$fn=64;


module middle_cylinder()
{
    offset = hub_height + 7;
    axial_bearing_height = 6.5;

    difference()
    {
        cylinder(h = cylinder_length, r = cylinder_radius);
        translate([0, 0, -0.05]) cylinder(h = hub_height + 0.05, r = hub_outer_radius);
        cylinder(h = cylinder_length, r = shaft_radius);

        translate([0, 0, cylinder_length - hub_height - axial_bearing_height])
        cylinder(h = hub_height, r = hub_outer_radius);

        translate([0, 0, cylinder_length - axial_bearing_height]) 
        cylinder(h = axial_bearing_height+0.05, r = axial_bearing_radius);

        translate([0, 0, offset]) 
        cylinder(h = cylinder_length / 2 - offset, r = hub_outer_radius);
    }
}


module arm()
{
  mounting_pad_thickness = 3;
  x_scale = 0.8;

  difference()
  {
    union()
    {
      hull()
      {
        hull()
        {
          translate([-motor_holder_width / 2, total_width / 2 - mounting_pad_thickness, 0]) 
            cube(size = [motor_holder_width, mounting_pad_thickness, cylinder_length]);
          //translate([0, total_width / 2 - mounting_pad_thickness / 2, cylinder_length / 2]) 
          //  roundedBox([motor_holder_width, mounting_pad_thickness, cylinder_length], mounting_pad_thickness / 2, true);
          translate([0, cylinder_radius+5, cylinder_length / 2]) 
          rotate([-90, 0, 0]) 
          scale([x_scale, 1, 1])
            cylinder(h = 1, r = 10);
        }
      }

      difference()
      {
        hull()
        {
          translate([0, hub_outer_radius+3, cylinder_length / 2]) 
          rotate([-90, 0, 0]) 
          scale([x_scale, 1.8, 1])
            cylinder(h = 1, r = 10);
          translate([0, cylinder_radius+5, cylinder_length / 2]) 
          rotate([-90, 0, 0]) 
          scale([x_scale, 1, 1])
            cylinder(h = 1, r = 10);
        }
        hull()
        {
          translate([0, hub_outer_radius+3, cylinder_length / 2]) 
          rotate([-90, 0, 0]) 
          scale([x_scale / 2, 1.8 / 2, 1 / 2])
            cylinder(h = 1, r = 10);
          translate([0, cylinder_radius+5, cylinder_length / 2]) 
          rotate([-90, 0, 0]) 
          scale([x_scale / 2, 1 / 2, 1 / 2])
            cylinder(h = 1, r = 10);
        }
      }
    }

    // Mounting holes
    translate([-motor_holder_mounting_hole_shift,
            total_width / 2 - mounting_pad_thickness - 1,
            cylinder_length - mount_hole_z])
    rotate([-90, 0, 0])
      mounting_hole(mounting_pad_thickness * 1.3, true);
  
    translate([-motor_holder_mounting_hole_shift,
            total_width / 2 - mounting_pad_thickness - 1,
            mount_hole_z])
    rotate([-90, 0, 0])
      mounting_hole(mounting_pad_thickness * 1.3, true);

    translate([motor_holder_mounting_hole_shift,
            total_width / 2 - mounting_pad_thickness - 1,
            mount_hole_z])
    rotate([-90, 0, 0])
      mounting_hole(mounting_pad_thickness * 1.3, true);
  }
}

module hole()
{
    rotate([90, 0, 0])
    translate([motor_holder_mounting_hole_shift,
            cylinder_length - mount_hole_z,
            -(total_width + tolerance) / 2])
    cylinder(h = total_width + tolerance, r = mount_hole_radius);
}

module mount_pad_holes()
{
  for(i = [30 : 60 : 390])
  {
    rotate(i, [0, 0, 1])
    translate([0, 9.53, 0])
    if(i == 90 || i == 270)
    {
        cylinder(r = 1.25 * 2, h = cylinder_length);
    }
    else
    {
        cylinder(r = 1.25, h = cylinder_length);
    }
  }
}

//=====================================================

module whole_part()
{
    difference()
    {
        union()
        {
            middle_cylinder();

            arm();
            mirror([0, 1, 0]) arm();
        }

        hole();  
        mount_pad_holes();
    }
}

// Bottom part to print
module bottom_part()
{
    translate([0, 0, cylinder_length / 2])
    rotate([0, 180, 0])
    difference()
    {
        whole_part();
        translate([-40, -40, cylinder_length / 2])
        cube([80, 80, cylinder_length]);
    }
}

// Top part to print
module top_part()
{
    translate([0, 0, -cylinder_length / 2])
    difference()
    {
        whole_part();
        translate([-40, -40, -cylinder_length / 2])
        cube([80, 80, cylinder_length]);
    }
}


if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    //top_part();
    //bottom_part();

    difference()
    {
        whole_part();
        cube(size = [100, 100, 100]);
    }

}
