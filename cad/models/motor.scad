include <main_dimensions.scad>

module motor()
{
    motor_r1 = 36.7 / 2;
    motor_l1 = 18;
    motor_r2 = 33 / 2;
    motor_l2 = 22.3;

    // back shaft
    translate([0, 0, -motor_l1 - motor_l2 - 3 - 10]) cylinder(h = 10, r = 2 / 2);
    // back shaft holder
    translate([0, 0, -motor_l1 - motor_l2 - 3]) cylinder(h = 3, r = 9 / 2);
    // thin back part
    translate([0, 0, -motor_l1 - motor_l2])
    cylinder(h = motor_l2, r = motor_r2);
    // thick front part
    translate([0, 0, -motor_l1])
    cylinder(h = motor_l1, r = motor_r1);

    translate([0, -motor_shaft_shift, 0])
    {
        // front shaft holder
        cylinder(h = 5, r = 6);
        // front shaft
        translate([0, 0, 5]) cylinder(h = 18, r = 3);
    }
}

if(ASSEMBLY == undef || ASSEMBLY == 0)
{
    motor();
}
