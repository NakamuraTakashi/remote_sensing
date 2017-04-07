function d_es = earth_sun_distance(day,month,year,TIME0)

JD = julianday(day,month,year,TIME0);
D = JD - 2451545.0;
g = 357.529 + 0.98560028*D;
d_es = 1.00014 - 0.01671*cos(g) - 0.00014*cos(2*g);

end