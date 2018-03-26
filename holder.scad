tBarWidth = 15;
tBarHeight = 15;
tBarLength = 300;
tBarThickness = 1;

$fn = 30;


module tExtrusion(lenth, expansion)
{
	translate([0, -tBarWidth/2 - expansion, tBarHeight-tBarThickness])
	cube([lenth, tBarWidth+2*expansion, tBarThickness + 2*expansion]);

	translate([0, -tBarThickness/2 - expansion, 0])
	cube([lenth, tBarThickness + 2*expansion, tBarHeight + 2*expansion]);
}


difference()
{
	union()
	{
		tExtrusion(tBarLength, 0);

		translate([300/2 + 50, 0, 0])
		arm(100, 5/2);

			
		translate([300/2 - 50, 0, 0])
		translate([-25/2, 0, 15/2])
		rotate([0, 2.2, 0])
		translate([25/2, 0, -15/2])
		rotate([0, 0, 180])
		arm(100, 5/2);
	}
/*
	translate([0, 0, -100])
	cube([1000, 1000, 1000]);

	translate([0, -1000 - 2, -100])
	cube([1000, 1000, 1000]);
*/
}


module arm(h, circleR)
{
	extra = 5;
	thickness = 15;
	topBridge = 10;
	bridge = 5;
	sleeveLen = 25;
	armWidth = 10;

	difference()
	{
		union()
		{
			translate([0, -armWidth/2, tBarHeight + topBridge])
			cube([thickness, armWidth, h]);

			translate([0, 0, tBarHeight + topBridge + h - armWidth/2])
			rotate([0, 90, 0])
			cylinder(r = circleR*3, h = thickness);


			hull()
			{
				translate([0, -armWidth/2, tBarHeight + topBridge])
				cube([thickness, armWidth, 1]);

				translate([0, -tBarWidth/2 - extra, -bridge])
				cube([sleeveLen, tBarWidth + extra*2, tBarHeight + bridge*2]);
			}
		}

		translate([-1, 0, -0.5])
		tExtrusion(sleeveLen + 2, 0.5);

		translate([0, 0, tBarHeight + topBridge + h - armWidth/2])
		rotate([0, 90, 0])
		translate([0, 0, -1])
		cylinder(r = circleR, h = thickness + 2);
	}
}

