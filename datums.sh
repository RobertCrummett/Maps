gmt begin datums pdf
gmt grdcut @earth_relief_02m -R-125/-67/25/49 -JM6i -Ggrid.nc
gmt grd2xyz grid.nc > grid.xyz
gmt mapproject grid.xyz -Th219 -V > grid_wgs84.xyz
gmt mapproject grid.xyz -Th140 -V > grid_nad83.xyz
gmt mapproject grid.xyz -Th133 -V > grid_nad27.xyz
gmt mapproject grid_wgs84.xyz -E219 -V > grid_wgs84_xyz.xyz
gmt mapproject grid_nad83.xyz -E140 -V > grid_nad83_xyz.xyz
gmt mapproject grid_nad27.xyz -E133 -V > grid_nad27_xyz.xyz
gmt xyz2grd grid_wgs84_xyz.xyz -R-125/-67/25/49 $(gmt grdinfo grid.nc -I) -Ggrid_wgs84.nc
gmt xyz2grd grid_nad83_xyz.xyz -R-125/-67/25/49 $(gmt grdinfo grid.nc -I) -Ggrid_nad83.nc
gmt xyz2grd grid_nad27_xyz.xyz -R-125/-67/25/49 $(gmt grdinfo grid.nc -I) -Ggrid_nad27.nc
gmt grdmath grid_nad83.nc grid_nad27.nc SUB = grid_diff.nc
gmt grdimage grid_diff.nc -R-125/-67/25/49
gmt grdcontour grid_diff.nc -Baf -An
gmt end show
