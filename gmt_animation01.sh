#!/usr/bin/env bash
# GMT Animation 01
#
# Spinning moon example
# Simple movie

cat <<- 'EOF' > main.sh
gmt begin
    gmt grdimage @moon_relief_06m -JG-${MOVIE_FRAME}/30/${MOVIE_WIDTH} -Rg -Bg -X0 -Y0
gmt end show
EOF
gmt movie main.sh -C20cx20cx30 -T360 -Fmp4 -Mf,png -NMovie_Moon -Z
rm -f main.sh
