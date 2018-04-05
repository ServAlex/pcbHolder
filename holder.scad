include <wingedNut.scad>;
include <roundedCube.scad>;
include <jaws.scad>;

tBarWidth = 15;
tBarHeight = 15;
tBarLength = 300;
tBarThickness = 1.4;

$fn = 50;

// part for testing slot fit on t-bar
//testPart();

// whole assembly preview
//assembly();


// separate parts, uncomment one by one for rendering separate models
//arm(100, 5/2);
//joint(1);
//joint(2);
//wingedNut();
//jawsAssembly(6/2);

// jaw parts
shaftR = 6/2;
ballExpansion = 0.0;
//ball(shaftR, shaftR*2, wall = 1.5);
//jaw(shaftR*2 + ballExpansion, 1.5, width = 40, height = 19/2, mode = 4);
//jaw(shaftR*2 + ballExpansion, 1.5, width = 40, height = 19/2, mode = 5);

stabilizerArm(4);

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

				translate([300/2, 0, 0])
				stabilizerArm(0);

				translate([300/2 + (50 + 30)*i, 0, 100 + tBarHeight + 5])
				rotate([0, 90*i, 0])
				wingedNut();

				translate([300/2 + ( 30)*i, 0, 100 + tBarHeight+ 5 - 19/2])
				rotate([0, 0, 90*i])
				jawsAssembly(6/2);

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

module stabilizerArm(part = 0)
{
	extra = 5;
	thickness = 15;
	topBridge = 10;
	bridge = 5;
	sleeveWindowWidth = 3;
	sleeveGap = 8;
	sleeveLen = sleeveWindowWidth*2+sleeveGap;
	armWidth = 10;

	expansion = 0.3;

	windowWidth = 5;
	windowLength = 7;
	crossPinFixationLen = 2;
	ladderWallWidth = 1.6;
	windowTopBridge = ladderWallWidth;
	desiredLadderLength = 90;
	windowsCount = floor((desiredLadderLength - ladderWallWidth)/(windowWidth + ladderWallWidth));
	ladderLength = windowsCount*(windowWidth + ladderWallWidth) + ladderWallWidth;

	// rail sleeve
	if(part == 0 || part == 1)
	difference()
	{
		union()
		{
			hull()
			{
				translate([0, -armWidth/2, tBarHeight + expansion + crossPinFixationLen + ladderWallWidth + windowLength + windowTopBridge])
				rotate([0, 90, 0])
				roundedCube([3, armWidth, sleeveLen], 1);

				translate([0, -tBarWidth/2 - extra, -bridge])
				translate([sleeveLen, 0, 0])
				rotate([0, -90, 0])
				roundedCube([tBarHeight + bridge*2, tBarWidth + extra*2, sleeveLen], 2);
			}
		}

		translate([sleeveWindowWidth, -tBarWidth/2 - extra -1, tBarHeight + expansion + crossPinFixationLen])
		cube([sleeveGap, tBarWidth + extra*2 + 2, windowLength + 1 + 2 + 1]);

		translate([-1, -windowWidth/2, tBarHeight + expansion + crossPinFixationLen + ladderWallWidth])
		cube([sleeveLen+2, windowWidth, windowLength]);

		translate([-1, 0, -expansion])
		tExtrusion(sleeveLen + 2, expansion, expansion);
	}

	// ladder
	if(part == 0 || part == 2)
	{
		translate([sleeveWindowWidth, -windowWidth/2 - ladderWallWidth, tBarHeight + expansion + crossPinFixationLen])
		difference()
		{
			cube([sleeveGap, ladderLength, ladderWallWidth*2 + windowLength]);

			for(i = [0:1:windowsCount-1])
			translate([-1, ladderWallWidth + (windowWidth + ladderWallWidth)*i, ladderWallWidth])
			cube([sleeveGap + 2, windowWidth, windowLength]);
		}
	}

	// ladder cross pin
	if(part == 0 || part == 3)
	{
		translate([-2, -windowWidth/2, tBarHeight + expansion + crossPinFixationLen + ladderWallWidth - crossPinFixationLen])
		difference()
		{
			union()
			{
				translate([0, windowWidth, 0])
				rotate([90, 0, 0])
				roundedCube([sleeveLen + 4 + 5, windowLength-0.5, windowWidth-0.5], 2);

				translate([0, windowWidth, +0.25 -2])
				rotate([90, 0, 0])
				roundedCube([7, windowLength - 0.5 + 4, windowWidth-0.5], 2);
			}
			
			translate([3, 0, windowLength/2])
			rotate([-90, 0, 0])
			cylinder(r = 1.5, h = 20);
		}
	}

	desiredVerticalLadderLength = 100;
	verticalWindowsCount = floor((desiredVerticalLadderLength - ladderWallWidth)/(windowLength+ ladderWallWidth));
	verticalLadderLength = verticalWindowsCount*(windowLength+ ladderWallWidth) + ladderWallWidth;

	// vertical ladder
	if(part == 0 || part == 4)
	translate([ladderWallWidth, ladderLength - (windowWidth+ladderWallWidth)*0, tBarHeight + expansion + crossPinFixationLen])
	difference()
	{
		// main body
		translate([0, ladderWallWidth-0.8, 0])
		cube([sleeveGap + 2*ladderWallWidth, windowWidth+ladderWallWidth*5 + 0.5 -ladderWallWidth + 0.8, verticalLadderLength]);

		// middle cut
		translate([ladderWallWidth+0.4, ladderWallWidth, -1])
		cube([sleeveGap-0.4, windowWidth+ladderWallWidth*3+0.5, verticalLadderLength+ 2]);

		// windows
		for(i=[0:verticalWindowsCount-1])
		translate([-1, ladderWallWidth*3, ladderWallWidth + (ladderWallWidth + windowLength)*i])
		cube([sleeveGap+2 + 2*ladderWallWidth, windowWidth, windowLength]);

		// helper bridges
		for(i=[0:verticalWindowsCount-1])
		translate([ladderWallWidth, ladderWallWidth*(3-2), ladderWallWidth + (ladderWallWidth + windowLength)*i])
		cube([sleeveGap, windowWidth+ladderWallWidth+0.5+2*ladderWallWidth, windowLength]);

		// top separation cut
		translate([ladderWallWidth - ladderWallWidth - 1, ladderWallWidth*0, -1])
		cube([ladderWallWidth+1, ladderWallWidth*2, verticalLadderLength+ 2]);

		// bottom separation cut
		translate([sleeveGap + 1*ladderWallWidth-1, ladderWallWidth, -1])
		cube([ladderWallWidth+2, ladderWallWidth, verticalLadderLength+ 2]);
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

