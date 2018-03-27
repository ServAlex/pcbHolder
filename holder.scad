tBarWidth = 15;
tBarHeight = 15;
tBarLength = 300;
tBarThickness = 1.4;

$fn = 30;

assembly();
//testPart();

module tExtrusion(lenth, expansionHorizontal, expansionVertical)
{
	translate([0, -tBarWidth/2 - expansionHorizontal, tBarHeight-tBarThickness])
	cube([lenth, tBarWidth+2*expansionHorizontal, tBarThickness + 2*expansionVertical]);

	translate([0, -tBarThickness/2 - expansionHorizontal, 0])
	cube([lenth, tBarThickness + 2*expansionHorizontal, tBarHeight + 2*expansionVertical]);
}

module testPart()
{
	difference()
	{
		cube([23, 20, 25]);

		translate([2, 10, -1])
		rotate([0, -90, 180])
		#tExtrusion(27, 0, 0);
	}
}

module assembly()
{
	difference()
	{
		union()
		{
			tExtrusion(tBarLength, 0, 0);

			translate([300/2 + 50, 0, 0])
			arm(100, 5/2);

			translate([300/2 - 50, 0, 0])
	//		translate([-25/2, 0, 15/2])
	//		rotate([0, 2.2, 0])
	//		translate([25/2, 0, -15/2])
			rotate([0, 0, 180])
			arm(100, 5/2);

			joint();	
		}

	/*
		translate([-10, 0, -100])
		cube([1000, 1000, 1000]);

		translate([-10, -1000 - 2, -100])
		cube([1000, 1000, 1000]);
	*/
	}
}

module joint()
{
	jointLen = 20;
	boltingWidth = 8;
	jointWidth = tBarWidth + 2*boltingWidth;
	cupHeight = 5;
	bottomHeight = 5;

	translate([0, 0, 0])
	difference()
	{
		translate([0, -jointWidth/2, -bottomHeight])
		cube([jointLen, jointWidth, tBarHeight - tBarThickness + bottomHeight]);

		translate([-1, 0, 0])
		tExtrusion(jointLen+2, 0.3, 0);
	}
}

module arm(h, circleR)
{
	extra = 5;
	thickness = 15;
	topBridge = 10;
	bridge = 5;
	sleeveLen = 25;
	armWidth = 10;

	expansion = 0.5;

	r = sleeveLen;
	d = tBarHeight;
	s = tBarHeight + 2*expansion;

	angle = asin( (-r*d+s*sqrt(s*s+r*r-d*d)) / (s*s+r*r));

	difference()
	{
		union()
		{
			hull()
			{
				translate([0, -armWidth/2, tBarHeight + topBridge])
				cube([thickness, armWidth, h-circleR*4]);

				translate([0, -armWidth/2, tBarHeight + topBridge])
				cube([sleeveLen, armWidth, 1]);
			}

			translate([0, 0, tBarHeight + topBridge + h - armWidth/2])
			rotate([0, 90, 0])
			cylinder(r = circleR*3, h = thickness);

			hull()
			{
				translate([0, -armWidth/2, tBarHeight + topBridge])
				cube([sleeveLen, armWidth, 1]);

				translate([0, -tBarWidth/2 - extra, -bridge])
				cube([sleeveLen, tBarWidth + extra*2, tBarHeight + bridge*2]);
			}
		}

		translate([-1, 0, -expansion])
		translate([sleeveLen/2, 0, tBarHeight/2])
		rotate([0, angle, 0])
		translate([-sleeveLen/2, 0, -tBarHeight/2])
		tExtrusion(sleeveLen + 2, expansion, expansion);

		translate([0, 0, tBarHeight + topBridge + h - armWidth/2])
		rotate([0, 90, 0])
		translate([0, 0, -1])
		cylinder(r = circleR, h = thickness + 2);
	}
}

