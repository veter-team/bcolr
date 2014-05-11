ASSEMBLY = 1;
//$fn=64;

use <holder-to-shaft-coupling.scad>
use <motor_holder.scad>
use <motor.scad>
use <bottom_plate.scad>
include <main_dimensions.scad>
include <dumper_shaft.scad>


explosion_distance = 3;

module asm_holder()
{
    translate([0,
            -total_width / 2 - explosion_distance,
            -motor_shaft_to_top + motor_shaft_shift + cylinder_length])
    rotate([90, 0, 0])
    holder_base();
}


whole_part();

translate([2 * explosion_distance, -explosion_distance, 0]) dumper_shaft();
mirror([0, 1, 0])
translate([2 * explosion_distance, -explosion_distance, 0]) dumper_shaft();

asm_holder();
mirror([0, 1, 0]) asm_holder();

translate([0, 0, cylinder_length + bottom_plate_base_height + 2 * explosion_distance])
rotate([180, 0, 0])
bottom_plate();

%translate([0,
        -total_width / 2 - explosion_distance,
        -motor_shaft_to_top + motor_shaft_shift + cylinder_length])
rotate([90, 0, 0]) motor();
