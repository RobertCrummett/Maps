# GMT Example 16
#
# Illustrate some interpolation methods that GMT offers.
# Delaunay triangulation by means of a contour or a
# triangulation are the most common means of interpolating
# irregular data. However, the method has limitations:
# it will not extrapolate beyond a convex hull of the
# data, and it does not produce a differentiable surface.
#
# Surface can be used to generate a higher order 
# interpolation onto a grid. Although it the surfaces become
# differentiable, they have drawbacks - default surface
# tension (minimum curvature settings, T=0) can
# over and underestimate data in a region (over and
# under shoot respectively). An intermediate tension
# value can be used as a trade off between minimum
# curvature and Delaunay triangulation. As always,
# there is a price to be paid though - tension tends
# to cause contours to turn perpendicular to the edges
# of the grid. We will see all of these feastures
# in the grids below.

gmt begin ex16
    gmt subplot begin 2x2 -M0.1c -Fs8c/0 -R-0.2/6.6/-0.2/6.6 -Jx1c -Scb -Srl+t -Bwesn -T"Gridding of Data"
        gmt surface @Table_5_11.txt -I0.2 -Graws0.nc
        gmt contour @Table_5_11.txt -C@ex_16.cpt -I -B+t"contour (triangulate)" -c0,0

        gmt grdview raws0.nc -C@ex_16.cpt -Qs -B+t"surface (tension = 0)" -c0,1

        gmt surface @Table_5_11.txt -Graws5.nc -T0.5
        gmt grdview raws5.nc -C@ex_16.cpt -Qs -B+t"surface (tension = 0.5)" -c1,0

        gmt triangulate @Table_5_11.txt -Grawt.nc
        gmt grdfilter rawt.nc -Gfiltered.nc -D0 -Fc1
        gmt grdview filtered.nc -C@ex_16.cpt -Qs -B+t"triangulate @~\256@~ grdfilter" -c1,1
    gmt subplot end
    gmt colorbar -DJBC -C@ex_16.cpt
gmt end
rm -f raws0.nc raws5.nc rawt.nc filtered.nc
