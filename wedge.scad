module wedge(len, depth, angle)
{
	translate([len/2, 0, 0])
	rotate([0, -90, 0])
	linear_extrude(height = len)
	{
		polygon([[0,0], [depth, tan(angle)*depth], [depth, -tan(angle)*depth]]);
	}
}

