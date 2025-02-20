# GMT Example 09
#
# Time Series Along Tracks
# Display a set of Geosat sea surface slope profiles.
# Add track numbers to the plot, and the location of 
# the Pacific-Arctic Ridge. The profile ID's are
# contained in the section headers. Use the last data
# point in each of the track segments to construct an
# input file for text that will label each profile with
# a track number.
#
# NOTE
# Offset the positions of labels by 4 and with -D in
# order to have a small gap between the profile and
# track label.

gmt begin ex09
    gmt wiggle @tracks_09.txt -R185/250/-68/-42 \
        -Jm0.35c -B -BWSne+ghoneydew -Gred+p \
        -Gblue+n -Z750c -Wthinnest -DjBR+w500+l@~m@~rad+o0.5c \
        --FORMAT_GEO_MAP=dddF
    gmt plot @ridge_09.txt -Wthicker
    gmt plot @fz_09.txt -Wthinner,-
    # Take label from segment header and plot near
    # coordinates of last record of each track
    gmt convert -El @tracks_09.txt | gmt text \
        -F+f10p,Helvetica-Bold+a50+jRM+h -D-4p \
        -Ghoneydew
gmt end show

