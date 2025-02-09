#!/usr/bin/env bash
# GMT Animation Example 02
#
# Indiana Jones Animation Map
cp data/WED-A_Vid_4.zip .
unzip WED-A_Vid_4.zip

cat << 'EOF' > pre.sh
# Dr. Jones stop over cities
cat <<- 'FILE' > cities.txt
-74.007 40.712 New York
-52.712 47.562 St. John's (Newfoundland)
-25.696 37.742 São Miguel (Azores)
-9.135  38.776 Lisbon
12.342  45.503 Venice
FILE
gmt begin
    # Get length of travel and compute line increment in km per frame
    dist_to_Venice=$(gmt mapproject -G+uk cities.txt | gmt convert -El -o2)
    line_increment_per_frame=$(gmt math -Q ${dist_to_Venice} -1 ${animation_duration} ${MOVIE_RATE} MUL ADD DIV =) # in km

    gmt sample1d cities.txt -T${line_increment_per_frame}k+a > distance_vs_frame.txt
    gmt mapproject cities.txt -G+uk > labels.txt
gmt end
EOF

cat << 'EOF' > in.sh
    animation_duration=27 # in seconds
EOF

cat << 'EOF' > title.sh
gmt begin
    echo "12 11.5 Dr. Jones' flight to Venice on his Last Crusade" | \
        gmt text -R0/24/0/13.5 -Jx1c -F+f26p,Helvetica-Bold+jCB -X0 -Y0
    gmt text -M -F+f14p <<- END
> 12 6.5 16p 20c j
We will simulate the flight path from New York to Venice through three stepovers.
First, we do some calculations to set a fixed duration of the movie.
Then, we interpolate between the cities along a rhumb line.
We also make a separate file for the labels.
Finally, we make a Mercator map centered on the changing longitude and latitude.
We draw the path with a red line. The name of the cities will appear along with a circle showing its location.
END
    # Place the GMT Logo and Indiana Jones movie logo along the bottom
    gmt image IndianaJones_Logo.png -DjBR+jBR+w0/3c+o2/1c
    gmt logo -DjBL+h3c+o2c/1c
gmt end
EOF

cat << 'EOF' > main.sh
gmt begin
    gmt coast -JM${MOVIE_COL0}/${MOVIE_COL1}/${MOVIE_WIDTH} \
        -Y0 -X0 -R480/270+uk -G200 -Sdodgerblue2 -N1/0.2,-
    
    gmt events distance_vs_frame.txt -W3p,red -T${MOVIE_COL2} -Es -Ar
    gmt events labels.txt -T${MOVIE_COL2} -L500 -Mt100+c100 \
        -F+f18p+jTC -Dj1c -E+r100+f100+o-250 -Gred -Sc0.3c
gmt end
EOF

gmt movie main.sh -Iin.sh -Sbpre.sh -NIndiana_Jones -Tdistance_vs_frame.txt \
    -AIndianaJones_RaidersMarch.mp3 -Cfhd -Fmp4 -Vi -D60 -K+p -Zs \
    -Etitle.sh+d6s+fo1s

rm -f IndianaJones_RaidersMarch.mp3 IndianaJones_Logo.png WED-A_Vid_4.zip
