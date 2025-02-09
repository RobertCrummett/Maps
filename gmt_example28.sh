#!/usr/bin/env bash
# GMT Example 28
#
# Mix UTM and Geographic datasets
# Plot data set given in UTM coordinates (meter) and
# want it to be properly registered with overlay
# geographic data. A common mistake is to specify the
# UTM projection with the UTM data, not understanding
# the data has already been projected and is in linear
# meters to begin with. The way said data should be
# plotted is with a linear projection, yielding a UTM
# map. In this step UTM meters can be selected for
# annotations. 
#
# To plot geographic data on the same map, simply
# specify the region in UTM meters but supply the
# actual UTM projection parameters. The same scale
# must be used for geographic data as was used for
# the UTM data.

gmt begin ex28
	# Set up a color table
	gmt makecpt -Ccopper -T0/1500
	# Lay down the UTM topo grid using a 1:160,000 scale
	gmt grdimage @Kilauea.utm.nc -I+d -Jx1:160000 \
		--FONT_ANNOT_PRIMARY=9p
	# Overlay geographic data and coregister by using correct
	# region and gmt projection with the same scale
	gmt coast -R@Kilauea.utm.nc -Ju5Q/1:160000 -Df+ \
		-Slightblue -W0.5p -B5mg5m -BNE \
		--FONT_ANNOT_PRIMARY=12p --FORMAT_GEO_MAP=ddd:mmF
	echo 155:16:20W 19:26:20N KILAUEA | \
		gmt text -F+f12p,Helvetica-Bold+jCB
	gmt basemap --FONT_ANNOT_PRIMARY=9p --FONT_LABEL=10p \
		-LjRB+c19:23N+f+w5k+l1:160000+u+o0.5c
	# Annotate in km but append ,000m to annotations to get
	# customized meter labels
	gmt basemap -R@Kilauea.utm.nc+Uk -Jx1:160 -BWSne \
		-B5g5+u"@:8:000m@::" --FONT_ANNOT_PRIMARY=10p \
		--MAP_GRID_CROSS_SIZE_PRIMARY=0.25c --FONT_LABEL=10p
gmt end show
