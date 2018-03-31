module wingedNut()
{
	rad1 = 5.2/2;
	rad2 = 12/2;
	coneR = 4;
	bodyR = rad2 + 1;
	height = 10;
	wingLen = 30;


	difference()
	{
		union()
		{
			cylinder(r = bodyR, h = height);

			for(i=[-1:2:1])
			hull()
			{
				cylinder(r = bodyR, h = height-2.5);
				
				translate([wingLen*i, 0, 0])
				cylinder(r = 2, h = height+4);
			}
		}

		translate([0, 0, -1])
		cylinder(r = rad1, h = height + 5);

		translate([0, 0, height - (rad2 - rad1) + 0.01])
		cylinder(r1 = rad1, r2 = rad2, h = (rad2-rad1));
	}
}

