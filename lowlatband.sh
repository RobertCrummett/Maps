# Global low latitude figure
year=2024

# Generate points to sample IGRF at
gmt grdmath -I1 -R-180/180/-50/50 0 = global.nc
gmt grd2xyz global.nc > global.xyz

# Sample magnetic inclination from IGRF and grid the file
gmt mgd77magref global.xyz -A+a0+t${year}+y -Fi/0 > igrf.txt
gmt convert global.xyz igrf.txt -A -o0,1,3 > igrf.xyz
gmt xyz2grd igrf.xyz -Gigrf.nc -I1 -R-180/180/-50/50

# Contour the file, and dump the equator contour to an output file
gmt grdcontour igrf.nc -C1 -D -L30/30   > contour30n.xyz
gmt grdcontour igrf.nc -C1 -D -L-30/-30 > contour30s.xyz

awk 'length($1) <= 4 {print $1 " " $2}' contour30n.xyz > contourN.txt
awk 'length($1) <= 4 {print $1 " " $2}' contour30s.xyz > contourS.txt

awk 'NR > 1 {print $1 " " $2}' contourN.txt | gmt convert > contourR.txt
awk 'NR > 1 {print $1 " " $2}' contourS.txt | gmt convert -I >> contourR.txt

cat contourN.txt contourS.txt > contour.txt

# # Calculate the percentage of land
# gmt grdlandmask -Gland.nc -I0.1 -N0/1/1/1/1 -Rg
# gmt grdmask contourR.txt -Gmask.nc -I0.1 -N0/0/1 -Rg
# gmt grdmath land.nc AREA MUL = landarea.nc
# gmt grdmath land.nc mask.nc MUL AREA MUL = maskarea.nc
# 
# gmt grd2xyz landarea.nc > landarea.txt
# gmt grd2xyz maskarea.nc > maskarea.txt
# 
# awk '{landsum += $3} END {print landsum}' landarea.txt > landarea
# awk '{masksum += $3} END {print masksum}' maskarea.txt > maskarea
# echo "$(gmt math maskarea landarea DIV 100 MUL =)% of land is within 30 degrees of the magnetic equator"

# Plot
gmt begin low_latitude_globe pdf
gmt set PS_PAGE_COLOR black
gmt coast -Rd -JN24c -Bg30 -Gdarkgoldenrod3 -S135/189/246 -A10000
gmt plot contour.txt -Wthick,red
gmt plot contourR.txt -Gred@50
gmt basemap -BWSNE
gmt end show

# Cleanup
rm -f global.nc global.xyz
rm -f igrf.txt igrf.xyz igrf.nc
rm -f contour30n.xyz contour30s.xyz
rm -f contourN.txt contourS.txt contour.txt contourR.txt
rm -f land.nc mask.nc
rm -f maskarea.nc maskarea.txt maskarea
rm -f landarea.nc landarea.txt landarea
