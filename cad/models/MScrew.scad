/*

By: 

	Henrik K. Larsen, Feb. 2013, hkl@bitfix.dk

License: 

	Thingiverse license as stated.

File: 

	MScrew.scad, created with openSCAD 2013.01

Description:

	Metric screw library, version 1.0 final
	
	(Thread thickness adjusted for PLA print.)

	Build screws and matching nuts from the Metric system.

	Sizes from M2 through to M14, excluding M11 and M13 (not in standard)

	Measures follow the ISO standard.

	Threads spacing follow the standard.

	All measures are in mm.

	The threads profile (if cut) does not follow any standard.
	The thread profile is shaped to better suit printed plastic.

	Thread shape:
							********
									*
									*
							********
			    	********
			********
			*
			*
			********
					********
							********
									*
									*
							********

Current limitations:

	Shape and size of countersunk head not verified.
	Phillips slot not correct size and shape.
	Screw size not verified with correct torx size

Callable Modules:

	screw(
			<"M2"|"M3"|"M4"|"M5"|"M6"|"M7"|"M8"|"M10"|"M12"|"M14"> {screw M size},
			<"bolt"|"cs"> {screw head type},
			<int> {thread length in mm}
		);

	nut(
			<"M2"|"M3"|"M4"|"M5"|"M6"|"M7"|"M8"|"M10"|"M12"|"M14"> {nut M size}
			[,<length> {optional height of nut, default to standrd}]
		);

Here we go....

*/

// Create a list of metric standard measures
// From left to right: 
// Name, Thread spacing, outer Ø, inner ø, nut flat to flat measure, torx index

M_std = [
	["M2", 0.40,  2,  1.6,  5, "T8"],
	["M3", 0.50,  3,  2.5,  6, "T15"],
	["M4", 0.70,  4,  3.3,  7, "T25"],
	["M5", 0.80,  5,  4.2,  8, "T30"],
	["M6", 1.00,  6,  5.0, 10, "T40"],
	["M7", 1.00,  7,  6.0, 12, "T45"],
	["M8", 1.25,  8,  6.8, 13, "T50"],
	["M10",1.50, 10,  8.5, 17, "T55"],
	["M12",1.75, 12, 10.2, 22, "T60"],
	["M14",2.00, 14, 12.0, 27, "T70"]
];

// Torx standard measures
// From left to right: 
// T Name, outer diameter in inches, inner diameter in inches
// 
T_std = [
	["T1",0.033,0.024],
	["T2",0.037,0.027],
	["T3",0.044,0.032],
	["T4",0.051,0.036],
	["T5",0.055,0.040],
	["T6",0.066,0.048],
	["T7",0.077,0.056],
	["T8",0.090,0.065],
	["T9",0.097,0.070],
	["T10",0.107,0.077],
	["T15",0.128,0.092],
	["T20",0.151,0.109],
	["T25",0.173,0.124],
	["T27",0.195,0.140],
	["T30",0.216,0.155],
	["T40",0.260,0.187],
	["T45",0.306,0.218],
	["T50",0.346,0.242],
	["T55",0.440,0.312],
	["T60",0.520,0.372],
	["T70",0.610,0.435],
	["T80",0.689,0.497],
	["T90",0.782,0.558],
	["T100",0.870,0.620],
];

/**************************************************************************

N U T subs

**************************************************************************/

// Create a solid 6 sided nut body specified in mm and length and given fillet
// Called by screw_head, nut_body
module nut_body(mm, nh) {
	// take into account how fillet changes size of target body
	// minkowski() expands the target object
	fi = mm / 20;
	bs = ((mm / cos(30)) / 2) - fi; // radius -> only outer side has fillet
	ih = nh - 2 * fi; // both ends are fillet
	translate([0,0,fi]) 
		minkowski() {
			linear_extrude(height=ih) 
				polygon([
				[bs*sin(  0), bs*cos(  0)],
				[bs*sin( 60), bs*cos( 60)],
				[bs*sin(120), bs*cos(120)],
				[bs*sin(180), bs*cos(180)],
				[bs*sin(240), bs*cos(240)],
				[bs*sin(300), bs*cos(300)],
			]);
			// fillet expands the body it affects
			sphere(fi);
		}
}

module nut_thread(tout, tinn, tl, ts, print, debug) {
	if(debug) {
		echo (str("nut_thread(",tout,", ",tinn,", ",tl,", ",ts,", ",fi,")"));
	}
	translate([0,0,-tl/2]) union() {
		screw_body(tout, tinn, 2*tl, ts, true, print);
	}
}

/**************************************************************************

S C R E W subs

**************************************************************************/

module screw_body(tout, tinn, tl, ts, nut=false, print) {
	intersection() {
		union() {
			if(print) {
				cylinder(r=tinn, h=tl);
				screw_thread(tout, tinn, tl, ts, nut, print);
			}
			else {
				cylinder(r=tout, h=tl);
			}
		}
		union() {
			translate([0,0,tl-(1.2*tout)]) 
				cylinder(h=2*tout, r1=2*tout, r2=0);
			translate([0,0,-tout]) 
				cylinder(h=tl, r=tout);
		}
	}
}

module screw_thread(tout, tinn, tl, ts, nut=false, print) {
	turns = (tl / ts) * 360;
	echo(str("Turns = ", turns/360));

	intersection() {
		linear_extrude(height=tl, twist=-turns) {
			translate([tout-tinn,0,0]) {
				if(nut==true) {
	 				circle(1.10*(tinn+tout)/2);
				}
				else {
 					circle(0.90*(tinn+tout)/2);
				}
			}
		}
		cylinder(tl, tout, tout);
	}
}

module slot_phillips(width, length){
	phillips = 2;
	union() {
		translate([-2.828*width,phillips/2,length+2.414*width]) 
			rotate([90,45,0]) 
				cube([4*width,4*width,phillips]);
		rotate([0,0,90]) 
			translate([-2.828*width,phillips/2,length+2.414*width]) 
				rotate([90,45,0]) 
					cube([4*width,4*width,phillips]);
	}
}

module slot_torx(torx, height) {
	tout = torx[1] * 25.4;
	tinn = torx[2] * 25.4;
	echo(torx[0], tout, tinn);
	factor = cos(30);
	echo("factor:",factor, " height:", height);
	nw = tout * factor;
	rinn = tinn / 2;
	rdiff = rinn;
	translate ([0,0,-height/3]) {
		difference() {
			nut_body(nw, height);
			for(a = [30 : 60 : 330]) {
				translate([sin(a)*(rinn+rdiff), cos(a)*(rinn+rdiff), 0]) 
					cylinder(height, rdiff, rdiff, $fn=50);
			}
		}
	}
}

module cap_head(tout, tinn, torx) {
	cw = 1.5 * tout;
	fi = cw / 20;
	cwl = cw - (2 * fi);
		translate([0,0,-cwl]) {
			difference() {
				translate([0,0,-fi]) {
					minkowski() {
						cylinder(cwl, cwl, cwl);
						sphere(fi);
					}
				}
				slot_torx(torx, cwl);
			}
		}
}

/**************************************************************************

S P E C I F I C   S C R E W S

**************************************************************************/

//
// SCREW with ccountersunk head
//
// This type of head is always created with phillips slot
// 
// Mounting plane is top of head
//
module screw_with_cs_head(tout, tinn, tl, ts, slot, print) {
	union() {
		// build the head
		intersection() {
			difference() {
				// head body
				cylinder(h=tout,r1=2*tout, r2=tout);
				// slot in head
				translate([0,0,-1.414*tout]) slot_phillips(tout/2,0);
			}
			// cut the rim off the head
			translate([0,0,0]) cylinder(h=tout, r=1.9*tout);
		}
		// build the threaded part
		translate([0,0,tout]) 
			screw_body(tout, tinn, tl, ts, false, print);
	}
}

//
// SCREW with nut head
//
// This type of head do not have slot
//
// Mounting plane is between head and thread
//
module screw_with_nut_head(tout, tinn, tl, ts, hw, hl, print) {
	union() {
		translate([0,0,-hl]) nut_body(hw, hl);
		screw_body(tout, tinn, tl, ts, false, print);
	}
}

//
// SCREW with cap head
// 
// This type of head is always created with torx slot
//
// Mounting plane is between head and thread
//
module screw_with_cap_head(tout, tinn, tl, ts, torx, print) {
	union() {
		cap_head(tout, tinn, torx);
		translate([0,0,-0.1]) 
			screw_body(tout, tinn, tl + 0.1, ts, false, print);
	}
}

/**************************************************************************

C A L L A B L E   M O D U L E S

**************************************************************************/

module screw(msize, head, length, slot="torx", print=true, debug=false) {

	if(debug) {
		echo(str("screw('",msize,"', '",head,"', ", length, ")"));
	}

	// read from table
	m = M_std[search([msize],M_std)[0]];

	// measures are diameter, this system works with radius
	tout  = m[2] / 2; 
	tinn = m[3] / 2;
	ts = m[1];

	nw = m[4];
	nh = nw / 3;

	torx = T_std[search([m[5]],T_std)[0]];

	// if for printing, then create screw at it's printing plane,
	// else create screw at its mounting plane.
	xrot = print ? 0 : 180;
	bolttrs = print ? nh : 0;
	captrs = print ? tout * 1.5 : 0;

	rotate([xrot,0,0]) 
	// Actually this means that the head must draw the body and thread at the
	// correct height. Alternatively, there should be returns from modules..
	// Q: Are variables transported by reference, I doubt it!
	// So, the interface to screw head is all variables needed to draw full screw.
	if(head == "cs") {
		screw_with_cs_head(tout, tinn, length, ts, slot, torx, print);
	}
	else if(head == "nut") {
		translate([0,0,bolttrs]) 
			screw_with_nut_head(tout, tinn, length, ts, nw, nh, print);
	}
	else if(head == "cap") {
		translate([0,0,captrs]) 
			screw_with_cap_head(tout, tinn, length, ts, torx, print);
	}
}


module nut(standard, height=0, debug=false, print=true) {
	if(debug) {
		echo(str("nut(",standard,",",height,");"));
	}
	
	m = M_std[search([standard],M_std)[0]];
	ts = m[1];
	// increase nut inner dimension a bit
	tout  = m[2] / 1.95;
	tinn = m[3] / 1.95;
	nw = m[4];
	// use specified height, othervise use default calculated height
	nh = height == 0 ? nw / 2 : height;
	union() {
		difference() {
			nut_body(nw, nh);
			nut_thread(tout, tinn, nh, ts, print, true, debug);
		}
	}

	if(debug) {
		% translate([0,0,0]) cube([1, nw*1.2, nh]);
		% translate([-m[4]/2,0,0]) cube([m[4], 1, nh*1.2]);
		% translate([-tout,0,nh/2]) cube([2*tout, nw*1.2, 1]);
		% translate([-tinn,0,nh/2]) cube([2*tinn, nw*1.3, 1]);
	}  
}

/* 
*/	
d = true;
thread = false;
m = M_std[0];
x = 0;
y = 0;

//$fs=0.3;
color("steelblue")
{

/*
	Create a row of screws in every size defined
*/

	// set to true to generate this set
	if(false) {
		for(m = M_std) {
			assign(x = 10*m[2], y = 10*m[2]) {
				translate([x, y, 0]) 
					screw(m[0], "cap", 10, print=false);
				translate([x, y, 20]) 
					nut(m[0], print=true);
			}
		}
	}

/*
	Create a display of various screws
*/ 
	// set to true to create this set
	if(false) {
		// small screw
		screw("M4", "nut", 7, print=true);
	
		// standing nut
		translate([15,-20,3.5]) 
			rotate([90,30,90]) 
				nut("M4");
	
		// large countersunk screw with phillips
		translate([20,0,9]) 
			rotate([110,0,100]) 
				screw("M10", "cs", 10);
	
		// large caphead screw 
		translate ([15,25,17.5]) 
			rotate([180,0,0]) 
				screw("M10", "cap", 10, print=true);
		
		// medium countersunk screw on its head
		translate([-15,0,0]) 
			screw("M6", "cs", 8);
	
		// small nut besides screw above
		translate([-25,0,0]) 
			rotate([0,0,20]) 
				nut("M4");
		
		//larger nut in foregound
		translate([5,-10,0]) 
			nut("M6", debug=false);
	
		// screw with mounted nut
		translate([-15,25,6]) 
			rotate([90,30,110]) 
				union() {
					translate([0,0,0]) 
						rotate([0,180,0]) 
							screw("M8", "nut", 15, print=true);
					translate([0,0,0]) 
						nut("M8", 6);
				}
	}
} // end color

/*
	create a table for display
*/
if(false) {
	translate([-50,-50,-0.1]) 
		color("SteelBlue", 0.3) 
			cube([100,100,0.1]);
}

/*
Printable screw and nut.

Print with 0.2 layer thickness with PLA using fan cooling.

These two parts must fit together easily then.

*/

if(true) {
	screw("M8", "cap", 10, print=true);
	translate([15,0,0]) nut("M8", 6, print=true);
}
