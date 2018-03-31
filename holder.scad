include <wingedNut.scad>;
include <roundedCube.scad>;
include <jaws.scad>;

tBarWidth = 15;
tBarHeight = 15;
tBarLength = 300;
tBarThickness = 1.4;

$fn = 30;

// part for testing slot fit on t-bar
//testPart();

// whole assembly preview
//assembly();


// separate parts, uncomment one by one for rendering separate models
//arm(100, 5/2);
//joint(1);
//joint(2);
//wingedNut();
jawsAssembly(6/2);

// testing rounded cube
//roundedCube([10, 20, 5], 4, [0, 0, 0, 1]);
//roundedCube([10, 20, 5], 2);


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

			for(i = [-1:2:1])
			{
				translate([300/2 + 50*i, 0, 0])
				rotate([0, 0, 180*(i-1)/2])
				arm(100, 5/2);

				translate([300/2 + (50 + 30)*i, 0, 100 + tBarHeight + 5])
				rotate([0, 90*i, 0])
				wingedNut();

				translate([300/2 + (50 + 30)*i, 0, 100 + tBarHeight+ 5])
				rotate([0, 90*i, 0])
				jawsAssembly();

				translate([(300 - 20)*(i+1)/2, 0, 0])
				joint(0);
			}
		}

	/*
		translate([-10, 0, -100])
		cube([1000, 1000, 1000]);

		translate([-10, -1000 - 2, -100])
		cube([1000, 1000, 1000]);
	*/
	}
}

module joint(part)
{
	jointLen = 20;
	boltingWidth = 8;
	jointWidth = tBarWidth + 2*boltingWidth;
	cupHeight = 8;
	bottomHeight = 6;

	translate([0, 0, 0])
	difference()
	{
		union()
		{
			if(part == 2 || part == 0)
			{
				translate([0, -jointWidth/2, -bottomHeight])
				roundedCube([jointLen, jointWidth, tBarHeight - tBarThickness + bottomHeight], 5);

				// mounting plate
				translate([0, -jointWidth/2 - 10, -bottomHeight])
				roundedCube([jointLen, jointWidth + 10*2, 8], 5);
			}

			if(part == 1 || part == 0)
			// top lid
			translate([0, -jointWidth/2, tBarHeight])
			roundedCube([jointLen, jointWidth, cupHeight], 5);
		}

		translate([-1, 0, 0])
		tExtrusion(jointLen+2, 0.3, 0);

		translate([-1, -tBarThickness/2 - 0.3, -0.5])
		cube([jointLen+2, tBarThickness + 0.3*2, 1]);
		
		for(i=[-1:2:1])
		for(j=[-1:2:1])
		{
			// holes for bolts
			translate([jointLen/2 +i*(jointLen/4), j*(tBarWidth/2 + 4/2), - bottomHeight + 4 + 0.2])
			cylinder(r = 3.3/2, h = 40);

			// sinkholes for bolt heads
			translate([jointLen/2 +i*(jointLen/4), j*(tBarWidth/2 + 4/2), tBarHeight + cupHeight - 3])
			cylinder(r = 6/2, h = 40);

			// holes for nuts
			translate([jointLen/2 +i*(jointLen/4), j*(tBarWidth/2 + 4/2), -10 - bottomHeight + 4])
			cylinder(r = 6.2/2, $fn=6, h = 10);

			// holes for wood screws
			translate([jointLen/2 +i*(jointLen/4 + 0.5), j*(jointWidth/2 + 10-5), -10])
			cylinder(r = 4/2, h = 40);
		}
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

	expansion = 0.3;

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
				cube([thickness, armWidth, h-circleR*3]);

				translate([0, -armWidth/2, tBarHeight + topBridge])
				cube([sleeveLen, armWidth, 1]);
			}

			translate([0, 0, tBarHeight + topBridge + h - armWidth/2])
			rotate([0, 90, 0])
			cylinder(r = circleR*2.5, h = thickness);

			hull()
			{
				translate([0, -armWidth/2, tBarHeight + topBridge])
				cube([sleeveLen, armWidth, 1]);

				translate([0, -tBarWidth/2 - extra, -bridge])
				translate([sleeveLen, 0, 0])
				rotate([0, -90, 0])
				roundedCube([tBarHeight + bridge*2, tBarWidth + extra*2, sleeveLen], 2);
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

