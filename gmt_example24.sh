#!/usr/bin/env bash
# GMT Example 24
#
# Plot epicenters of some earthquakes
# Color the epicenters green if:
#  1. Located in the ocean
#  2. Within 3000 km of Hobart
#  3. More than 1000 km from the International dateline
# Otherwise color the epicenters red.

gmt begin ex24
    echo "147:13 -42:48 6000" > point.txt
    cat <<- 'END' > dateline.txt
> Our proxy for the dateline
180 0
180 -90
END
    R=$(gmt info -I10 @oz_quakes_24.txt)
    gmt coast $R -JM22c -Gtan -Sdarkblue -Wthin,white -Dl -A500 \
        -Ba20f10g10 -BWeSn
    gmt plot @oz_quakes_24.txt -Sc0.1c -Gred
    gmt select @oz_quakes_24.txt -Ldateline.txt+d1000k -Nk/s \
        -Cpoint.txt+d3000k -fg -Il | gmt plot -Sc0.1c -Ggreen
    gmt plot point.txt -SE- -Wfat,white
    gmt text point.txt -F+f14p,Helvetica-Bold,white+jLT+tHobart -Dj7p
    gmt plot point.txt -Wfat,white -S+0.5c
    gmt plot dateline.txt -Wfat,white -A
    rm -f point.txt dateline.txt
gmt end show
