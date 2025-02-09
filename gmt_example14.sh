# GMT Example 14
#
# Take irregularly sampled data onto a uniformly
# sampled grid. First plot the distribution of values
# of the original dataset. Then choose an eqidistant grid
# and run block mean (blockmean will preprocess the data
# to avoid aliasing). The process data is then gridded
# and contoured.
#
# NOTE:
# blockmean, blockmedian or blockmode should always
# be run prior to surface, and both of these steps
# must use the same gridding interval.

gmt begin ex14
    gmt set MAP_GRID_PEN_PRIMARY thinnest,-
    # calculate mean data and grids
    gmt blockmean @Table_5_11.txt -R0/7/0/7 -I1 > mean.xyz
    gmt surface mean.xyz -Gdata.nc
    gmt grdtrend data.nc -N10 -Ttrend.nc
    gmt project -C0/0 -E7/7 -G0.1 -N > track
    # sample along diagonal
    gmt grdtrack track -Gdata.nc -o2,3 > data.d
    gmt grdtrack track -Gtrend.nc -o2,3 > trend.d
    gmt plot -Ra -JX15c/3.5c data.d -Wthick -Bx1 -By50 -BWSne
    gmt plot trend.d -Wthinner,-
    gmt subplot begin 2x2 -M0.1c -Ff15c -BWSne -Yh+1c -R0/7/0/7
        # First draw network and label the nodes
        gmt plot @Table_5_11.txt -Sc0.12c -Gblack -c0,0
        gmt text @Table_5_11.txt -D3p/0 -F+f6p+jLM -N
        # Then draw gmt blockmean cells and label data values using one decimal
        gmt plot mean.xyz -Ss0.12c -Gblack -c0,1
        gmt text -D11p/0 -F+f6p+jLM+z%.1f -Gwhite -W -C1p -N mean.xyz
        # Then gmt surface and contour data
        gmt grdcontour data.nc -C25 -A50 -Gd8c -S4 -c1,0
        gmt plot mean.xyz -Ss0.12c -Gblack
        # Fit bicubic trend to data and compare to gridded gmt surface
        gmt grdcontour trend.nc -C25 -A50 -Glct/cb -S4 -c1,1
        gmt plot track -Wthick,.
    gmt subplot end
gmt end show
rm -f mean.xyz track trend.nc data.nc trend.d data.d
