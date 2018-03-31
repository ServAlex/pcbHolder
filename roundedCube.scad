
module roundedCube(v, radius, angles)
{
	rad = min(radius, min(v[0]/2, v[1]/2)-0.001);

	translate([rad, rad, 0])
	minkowski()
	{
		cube(v - [rad*2, rad*2, 0]);
		cylinder(r = rad, h = 0.01);
	}

	corners = [[0, 0], [0, 1], [1, 1], [1, 0]];
	for(a=[0:len(angles)-1])
	{
//		i = a%2;
//		j = floor(a/2)%2;
		i = corners[a][0];
		j = corners[a][1];
		echo(concat(str(a), str(angles[a]), str(i), str(j) ));
		if(angles[a]==1)
		{
			translate([(v[0] - rad)*i , (v[1] - rad)*j, 0])
			cube([rad, rad, v[2]]);
		}
	}
}
