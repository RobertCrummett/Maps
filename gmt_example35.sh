#!/usr/bin/env bash
# GMT Example 35
#
# Spherical triangulation and distance calculations

gmt begin ex35
# Get Voronoi polygons
gmt sphtriangulate @gshhs_c.txt -Qv -D > tt.pol
# Compute distances in kilometers
gmt sphdistance -Rg -I1 -Qtt.pol -Gtt.nc -Lk
gmt makecpt -Chot -T0/3500
# Make a basic image plot and overlay contours Voronoi polygons and coastlines
gmt grdimage tt.nc -JG-140/30/18c
gmt grdcontour tt.nc -C500 -A1000+f10p,Helvetica,white -L500 \
    -GL0/90/203/-10,175/60/170/-30,-50/30/220/-5 -Wa0.75p,white -Wc0.25p,white
gmt plot tt.pol -W0.25p,green,.
gmt coast -W1p -Gsteelblue -A0/1/1 -B30g30 -B+t"Distances from GSHHS crude coastlines"
rm -f tt.pol tt.nc gshhs_c.txt
gmt end show
