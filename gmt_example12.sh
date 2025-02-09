# GMT example 12
#
# Use `triangulate` to to perform the optimal Delaunay
# triangulation of non-uniformly distributed topography
# readings. Draw the graph. Labels nodes with their
# numbers and values. Also call contour to make a contour
# map of the data and image from the raw data.
#
# There will be no grid files of the data made, yet we
# will be able to plot the data.

gmt begin ex12
    # Contour the data and draw triangles using dashed pen.
    # Use `gmt gmtinfo` and `gmt makecpt` to make a color
    # pallete (.cpt) file.
    T=$(gmt info -T25+c2 @Table_5_11.txt)
    gmt makecpt -Cjet $T
    gmt subplot begin 2x2 -M0.1c -Fs8c/0 -Scb -Srl -R0/6.5/-0.2/6.5 -JX8c -BWSne -T"Delaunay Triangulation"
        # First draw network and label the nodes
        gmt triangulate @Table_5_11.txt -M > net.xy
        gmt plot net.xy -Wthinner -c0,0
        gmt plot @Table_5_11.txt -Sc0.3c -Gwhite -Wthinner
        gmt text @Table_5_11.txt -F+f6p+r
        # Draw network and print the node values
        gmt plot net.xy -Wthinner -c0,1
        gmt plot @Table_5_11.txt -Sc0.1c -Gblack
        gmt text @Table_5_11.txt -F+f6p+jLM -Gwhite -W -C1p -D6p/0i -N
        gmt contour @Table_5_11.txt -Wthin -C -Lthinnest,- -Gd3c -c1,0
        # Finally color the topography
        gmt contour @Table_5_11.txt -C -I -c1,1
    gmt subplot end
gmt end show

rm -f net.xy
