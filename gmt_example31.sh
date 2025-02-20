#!/usr/bin/env bash
# GMT Example 31
#
# Non default fonts in Post Script
# Fonts not apart of the standard PS collection must be embedded into PS by
# Ghost Script.

# Set AWK to awk if undefined
AWK=${AWK:-awk}

gmt begin ex31
# Set FONTPATH used in image conversion
# $(dirname 0) is the path to the current bash script
gmt set PS_CONVERT="C-sFONTPATH=$(dirname $0)/fonts"

# Create file PSL_custom_fonts.txt in current working directory and add
# Post Script font names of Linux Biolinum and Libertine
$AWK '{print $1, 0.700, 0}' <<- EOF > PSL_custom_fonts.txt
LinBiolinumO
LinBiolinumOI
LinBiolinumOB
LinLibertineOB
EOF

capitals=$(gmt which -G @europe-capitals-ru.csv)
# Common settings
gmt set FORMAT_GEO_MAP ddd:mm:ssF MAP_DEGREE_SYMBOL colon \
    MAP_TITLE_OFFSET 20p MAP_GRID_CROSS_SIZE_PRIMARY 0.4c PS_LINE_JOIN round \
    PS_CHAR_ENCODING ISO-8859-5 FONT LinBiolinumO \
    FONT_TITLE 24p,LinLibertineOB \
    MAP_ANNOT_OBLIQUE lon_horizontal,lat_parallel,tick_extend

# Map of countries
gmt coast -R-7/31/64/66+r -JL15/50/40/60/16c -Bx10g10 -By5g5 \
    -B+t"Europe\072 Countries and Capital Cities" -A250 -Slightblue \
    -Glightgreen -W0.25p -N1/1p,white
# Mark capitals
gmt plot @europe-capitals-ru.csv -i0,1 -Sc0.15c -G196/80/80
# Small EU cities
$AWK 'BEGIN {FS=","} $4 !="" && $4 <= 1000000 {print $1, $2}' $capitals | \
    gmt plot -Sc0.15c -W0.25p
# Big EU cities
$AWK 'BEGIN {FS=","} $4 > 1000000 {print $1, $2}' $capitals | \
    gmt plot -Sc0.15c -W1.25p
# Label big EU cities
$AWK 'BEGIN {FS=","} $4 > 1000000 {print $1, $2, $3}' $capitals | \
    gmt text -F+f7p,LinBiolinumOI+jBL -Dj0.1c -Gwhite -C5%+tO -Qu

# Construct legend
cat <<- EOF > legend.txt
G -0.1c
H 10p,LinBiolinumOB Population of the European Union capital cities
G 0.15c
N 2
S 0.15c c 0.15c 196/80/80 0.25p 0.5c < 1 Million inhabitants
S 0.15c c 0.15c 196/80/80 0.25p 0.5c > 1 Million inhabitants
N 1
G 0.15c
L 8p,LinBiolinumOB L Population in Millions
N 6
EOF

# Append city names and population to legend
$AWK 'BEGIN {FS=","; f="L 8p,LinBiolinumO L"} \
    $4 > 1000000 {printf "%s %s:\n%s %.2f\n", f, $3, f, $4/1e6}' \
    $capitals >> legend.txt

# Reduce annotation font size for legend
gmt set FONT_ANNOT_PRIMARY 8p

# Plot legend
gmt legend -DjTR+o0.1c+w8.0c+l1.2 -C0.3c/0.4c -F+p+gwhite legend.txt

rm -f legend.txt ex31CropNoLogo.eps europe-capitals-ru.csv
gmt end show
rm -f PSL_custom_fonts.txt
