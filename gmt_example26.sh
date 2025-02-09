#!/usr/bin/env bash
# GMT Example 26
#
# General vertical perspective projection
#
# Show a view of the eastern USA from 160 km
# up, with a tilt of 55 degrees and azimuth
# of 210.

gmt begin ex26
	# first do an overhead of the east coast from
	# 160 km alitude point straight down
	latitude=41.5
	longitude=-74
	altitude=160

	PROJ=-JG${longitude}/${latitude}/10c+z${altitude}
	gmt coast -Rg $PROJ -B5g5 -Glightbrown -Slightblue -W \
		-Dl -N1/1p,red -N2/0.5p -Y12c

	# Now point from an altitude of 160 km with a
	# specific tilt and azimuth and with a wider
	# restricted view and a boresight twist of 45
	# degrees.
	tilt=55
	azimuth=210
	twist=45
	Width=30
	Height=30

	PROJ=-JG${longitude}/${latitude}/12c+z${altitude}+a${azimuth}+t${tilt}+w${twist}+v${Width}/${Height}
	gmt coast $PROJ -B5g5 -Glightbrown -Slightblue -W -Ia/blue -Di -Na -X1i -Y-10c
gmt end show
