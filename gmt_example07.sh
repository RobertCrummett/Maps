#!/usr/bin/env bash
# GMT Example 07
#
# A location map for the equatorial Atlantic ocean,
# where fracture zones and mid ocean ridge segments
# have are plotted. Available earthquakes and 
# isochrons are also plotted.

gmt begin ex07
	gmt coast -R-50/0/-10/20 -JM24c -Slightblue -GP26+r300+ftan+bdarkbrown -Dl -Wthinnest -B --FORMAT_GEO_MAP=dddF
	gmt plot @fz_07.txt -Wthinner,-
	gmt plot @quakes_07.txt -h1 -Scc -i0,1,2+s0.025 -Gred -Wthinnest -l"ISC Earthquakes"+S0.4c
	gmt plot @isochron_07.txt -Wthin,blue
	gmt plot @ridge_07.txt -Wthicker,orange
	gmt legend -DjTR+o0.5c -F+pthick+ithinner+gwhite --FONT_ANNOT_PRIMARY=18p,Times-Italic
	gmt text -F+f30,Helvetica-Bold,white=thin <<- END
	-43 -5 SOUTH
	-43 -8 AMERICA
	 -7 11 AFRICA
	END
gmt end show
