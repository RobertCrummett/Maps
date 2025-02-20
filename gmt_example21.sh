#!/usr/bin/env bash
# GMT Example 21
#
# Plot a time series of the stock price of
# Red Hat, RHAT. The data comes in a text 
# file formatted like
#
# Date,Open,High,Low,Close,Volume,Adj.Close*
# 12-Mar-04,17.74,18.49,17.67,18.02,4827500,18.02
# 12-Mar-04,17.60,18.90,17.37,18.09,7700400,18.09
#
# Plot the opening price time series as a
# red line with a yellow envelope representing
# the low to high fluctuation of each day.

gmt begin ex21
    # File has time stored as dd-Mon-yy so set input format to match it
    gmt set FORMAT_DATE_IN dd-o-yy FORMAT_DATE_MAP o FONT_ANNOT_PRIMARY +10p
    gmt set FORMAT_TIME_PRIMARY_MAP abbreviated PS_CHAR_ENCODING ISOLatin1+

    # Extract a suitable region string in yyy-mm-dd format
    wesn=($(gmt info -fT -I50 -C @RHAT_price.csv --FORMAT_DATE_IN=dd-o-yy))
    R="-R${wesn[0]}/${wesn[1]}/${wesn[2]}/${wesn[3]}"

    # Lay down the base map
    gmt basemap $R -JX22c/15c -Bsx1Y -Bpxa3Of1o -Bpy50+p"$ " \
        -BWSen+t"RedHat (RHT) Stock Price Trend since IPO"+glightgreen

    # Plot main window with open price as red line over yellow envelope of low/high
    gmt set FORMAT_DATE_OUT dd-o-yy
    gmt convert -o0,2 -f0T @RHAT_price.csv > RHAT.env
    gmt convert -o0,3 -f0T -I -T @RHAT_price.csv >> RHAT.env
    gmt plot -Gyellow RHAT.env
    gmt plot @RHAT_price.csv -Wthin,red

    # Draw P Wessel's purchase price as line and label it. Note we temporary switch
    # back to default yyyy-mm-dd format since that is what gmt info gave us.
    echo "05-May-00 0" > RHAT.pw
    echo "05-May-00 300" >> RHAT.pw
    gmt plot RHAT.pw -Wthinner,-
    echo "01-Jan-99 25" > RHAT.pw
    echo "01-Jan-02 25" >> RHAT.pw
    gmt plot RHAT.pw -Wthick,-
    gmt set FORMAT_DATE_IN yyyy-mm-dd
    echo "${wesn[0]} 25 PW buy" | gmt text -D4c/0.1c -N -F+f12p,Bookman-Demi+jLB
    gmt set FORMAT_DATE_IN dd-o-yy
    
    # Draw P Wessel's sales price as line and label it.
    echo "25-Jun-07 0" > RHAT.pw
    echo "25-Jun-07 300" >> RHAT.pw
    gmt plot RHAT.pw -Wthinner,-
    echo "01-Aug-06 23.8852" > RHAT.pw
    echo "01-Jan-08 23.8852" >> RHAT.pw
    gmt plot RHAT.pw -Wthick,-
    gmt set FORMAT_DATE_IN yyyy-mm-dd
    echo "${wesn[1]} 23.8852 PW sell" | gmt text -Dj1.6c/0.1c -N -F+f12p,Bookman-Demi+jRB
    gmt set FORMAT_DATE_IN dd-o-yy

    # Get smaller region for inset for trend since 2004
    R="-R2004T/${wesn[1]}/${wesn[2]}/40"

    # Lay down the basemap, using Finnish annotations and place the inset in the upper right
    gmt basemap --GMT_LANGUAGE=fi $R -JX15c/7c -Bpxa3Of3o -Bpy10+p"$ " \
        -BESw+glightblue -Bsx1Y -X7c -Y8c
    
    # Again, plot close price as red line over yellow envelope of low/high
    gmt plot -Gyellow RHAT.env
    gmt plot @RHAT_price.csv -Wthin,red

    # Draw P Wessel's sales price as dashed line
    gmt plot RHAT.pw -Wthick,-

    # Mark sales date
    echo "25-Jun-07 0" > RHAT.pw
    echo "25-Jun-07 300" >> RHAT.pw
    gmt plot RHAT.pw -Wthinner,-

    # Clean after ourselves
    rm -f RHAT.*
gmt end show
