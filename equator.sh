#!/usr/bin/env bash
# Download north pole locations
url="https://www.ngdc.noaa.gov/geomag/data/poles/NP.xy"
if [ ! -f north-pole.txt ]
then
	curl $url > north-pole.txt
fi

# Movie main script
cat <<- 'END' > main.sh
gmt begin
# Compute year from frame
year=$(gmt math -Q ${MOVIE_FRAME} 1920 ADD =)
echo $year >> record.txt

# Generate points to sample IGRF at
gmt grdmath -I1 -R-180/180/-20/20 0 = global.nc
gmt grd2xyz global.nc > global.xyz

# Sample magnetic inclination from IGRF and grid the file
gmt mgd77magref global.xyz -A+a0+t${year}+y -Fi/0 > igrf.txt
gmt convert global.xyz igrf.txt -A -o0,1,3 > igrf.xyz
gmt xyz2grd igrf.xyz -Gigrf.nc -I1 -R-180/180/-20/20

# Contour the file, and dump the equator contour to an output file
gmt grdcontour igrf.nc -C1 -D -L0/0 > equator.xyz

# Convert the latitude in degrees to miles on a spherical earth
gmt math equator.xyz -C1 DEG2KM 0.621371 MUL --PROJ_ELLIPSOID=Sphere = equatorkm.xyz

# Fit the best great circle to the magnetic equator
center=$(gmt fitcircle equator.xyz -Fm -L2 --IO_COL_SEPARATOR=/)
pole=$(gmt fitcircle equator.xyz -Fn -L2 --IO_COL_SEPARATOR=/)
gmt project equator.xyz -C$center -Frs -S -T$pole > circle.txt
sort -nk1 circle.txt > circle-sorted.txt
gmt math circle-sorted.txt -C1 DEG2KM 0.621371 MUL --PROJ_ELLIPSOID=Sphere = circlekm.txt

# Select magnetic north pole for the year
lower=$(echo "$year - 0.5" | bc)
upper=$(echo "$year + 0.5" | bc)
gmt select north-pole.txt -Z${lower}/${upper} > magnetic-pole.txt

# Plot the distance from the equator
miles=2000
lat=$(gmt math -Q ${miles} 1.60934 MUL KM2DEG --PROJ_ELLIPSOID=Sphere =)
gmt basemap -R-180/180/-${lat}/${lat} -JX12c/6c -Bn
gmt coast -A10000 -Slightblue -Givory -Wthinnest,gray
gmt basemap -R-180/180/-${miles}/${miles} -JX12c/6c -Bxa40+l"Degrees Longitude"+u"@." -Bya500+l"Distance from Equator (miles)"
gmt plot circlekm.txt -W2p,green4
gmt plot equatorkm.xyz -W2p,blue
gmt plot -W2p,red <<- EOF
-180 0
180 0
EOF
echo -165 1500 "Year ${year}" | gmt text -C4p -F+f14p,Helvetica+jBL -Gwhite -W1p

# Plot a legend
gmt legend -DjBR+o0.5/0.5c+w4.2c -F+pthin+gwhite <<- EOF
P
S 0.1i - 0.15i - 2p,red 0.3i Geographic equator
S 0.1i - 0.15i - 2p,blue 0.3i Magnetic equator
S 0.1i - 0.15i - 2p,green4 0.3i Best fit great circle (L@-2@-)
EOF

# Plot the poles
gmt basemap -Baf -R-180/180/70/90 -JS0/90/20/12c -B+t"Equators & Poles in Time" --FONT_TITLE=32p,Palatino-Italic -Y+7c
gmt coast -A10000 -Slightblue -Givory -Wthinnest,gray -Bxa30g30
pole=$(gmt fitcircle equator.xyz -Fn -L2)
echo $pole | gmt plot -Sx0.5c -W3p,green4
gmt plot -Sx0.5c -W3p,blue < magnetic-pole.txt
echo 0 90 | gmt plot -Sx0.5c -W3p,red

# Plot a legend
gmt legend -DjBC+o0/0.75c+w3.5c -F+pthin+gwhite <<- EOF
S 0.1i x 0.15i red 2p 0.3i Geographic pole
S 0.1i x 0.15i blue 2p 0.3i Magnetic pole
S 0.1i x 0.15i green4 2p 0.3i Best fit pole (L@-2@-)
EOF

gmt end show
END

# Build movie
gmt movie main.sh -C16cx25cx80 -D8 -Fmp4 -Nequator -T106 -V -Z
