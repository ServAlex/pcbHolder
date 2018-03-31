include <wedge.scad>;

module jawsAssembly(shaftR)
{
	expansion = 0.2;

	translate([0, -shaftR*2*2.5 - expansion, 19/2])
	rotate([90, 0, 180])
	difference()
	{
		ball(shaftR, shaftR*2, wall = 1);
//		translate([-50, 0, -20])
//		cube([100, 100, 100]);
	}

	jaw(shaftR*2 + expansion, 1.5, 40, 19/2, 4);

	translate([0, 0, 19])
	rotate([0, 180, 0])
	jaw(shaftR*2 + expansion, 1.5, 40, 19/2, 5);

}

module jaw(sphereR, minWallThickness, width, height, mode = 2)
{
	// mode == 1 no screw hole
	// mode == 2 screw hole for thread
	// mode == 3 screw hole only
	// mode == 4 screw hole + screw head sink
	// mode == 5 screw hole + nut sink

	ballInsetFraction = 0.65;
	ballShellLen = sphereR*2*ballInsetFraction;
	ballShellOutterR = sphereR + minWallThickness;
	supportHalfWidth = ballShellOutterR*sin(42);
	surrationsDepth = 2;

	additionalHeight = (height - ballShellOutterR > 0)?height-ballShellOutterR:0;
	totalHeight = ballShellOutterR + additionalHeight;

	// ball joint
	translate([0, 0, totalHeight])
	rotate([90, 0, 0])

	difference()
	{
		union()
		{
			cylinder(r = ballShellOutterR, h = ballShellLen);
			
			hull()
			{
				translate([-supportHalfWidth, -ballShellOutterR*sin(90-42), 0])
				cube([supportHalfWidth*2, ballShellOutterR*sin(90-42), ballShellLen]);

				translate([-supportHalfWidth+3, -totalHeight, 0])
				cube([supportHalfWidth*2 - 6, 0.1, ballShellLen]);
			}
		}

		translate([-ballShellOutterR, 0, -1])
		cube([ballShellOutterR*2, ballShellOutterR*2, ballShellLen+2]);

		translate([0, 0, sphereR])
		sphere(r = sphereR);

		for(i=[0:1])
			rotate([0, 0, 90*i])
			translate([-ballShellOutterR*2, -0.5, ballShellLen - sphereR])
			cube([ballShellOutterR*4, 1, ballShellLen]);
	}

	jointSinkDistance = 5;

	// jaw body
	difference()
	{
		translate([-width/2, -jointSinkDistance, 0])
		cube([width, surrationsDepth + 2 + jointSinkDistance, totalHeight]);

		translate([0, 0, totalHeight])
		rotate([90, 0, 0])
		cylinder(r = ballShellOutterR + 2, h = ballShellLen);

		rotate([0, 0, 180])
		translate([-supportHalfWidth -2, 0, -1])
		cube([supportHalfWidth*2+4, jointSinkDistance + 1, ballShellOutterR+2]);

		for(i=[-1:2:1])
		translate([i*(ballShellOutterR + 2 + 3/2+0.5), -3/2, -1])
		{
			translate([0, 0, (mode>3)?(3 +1+0.2):0])
			cylinder(r = (mode>2?3.3:2.7)/2, h = 100);

			if(mode==4)
			// planning for bolt heads
			cylinder(r = 5/2, h = 3 + 1);

			if(mode==5)
			cylinder(r = 6.2/2, $fn=6, h = 3 + 1);
		}

		// surrations
		// horizontal
		for(i = [0,1])
		translate([0, 2+0.1, totalHeight - i*6])
		rotate([-90, 0, 0])
		wedge(width + 1, surrationsDepth, 35);

		// vertical
		for(i = [-2:1:2])
		translate([width/4*i, 2+0.1, totalHeight])
		rotate([-90, 90, 0])
		wedge(totalHeight*2 + 1, surrationsDepth, 35);
	}
}

module ball(shaftR, sphereR, wall = 1)
{
	difference()
	{
		union()
		{
			translate([0, 0, sphereR*1.5])
			sphere(r = sphereR);

			cylinder(r = shaftR+wall, h = shaftR*4);
		}

		translate([0, 0, shaftR*3.8])
		cylinder(r1 = shaftR*0.9, r2 = 0, h = shaftR*0.9);
		translate([0, 0, -1])
		cylinder(r = shaftR*0.9, h = shaftR*4+1);
	}
}


