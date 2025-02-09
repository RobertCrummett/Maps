# GMT Example 02
#
# Plot two 2D grids of bathymetry and Geosat geoid
# heights from globals grids. The region of interest
# is the Hawaiian islands. Plot the data using an
# oblique Mercator projection defined by the hot
# spot pole (68W, 69N). Choose the point (190, 25.5)
# to be the center of the projection (i.e. the local
# origin).

gmt begin ex02
    gmt set MAP_ANNOT_OBLIQUE separate
    gmt subplot begin 2x1 -A+JTL -Fs16c/9c -M0 -R160/20/220/30+r -JOc190/25.5/292/69/16c -B10 -T"H@#awaiian@# T@#opo and @#G@#eoid@#"
        gmt subplot set 0,0 -Ce3c
        gmt grd2cpt @HI_topo_02.nc -Crelief -Z
        gmt grdimage @HI_topo_02.nc -I+a0
        gmt colorbar -DJRM+o1c/0+mc -I0.3 -Bx2+lTOPO -By+lkm

        gmt subplot set 1,0 -Ce3c
        gmt makecpt -Crainbow -T-2/14/2
        gmt grdimage @HI_geoid_02.nc 
        gmt colorbar -DJRM+1c/0+e+mc -Bx2+lGEOID -By+lm
    gmt subplot end
gmt end show

# NOTES
#
# MAKECPT
# generates a linear color palette file for the geoid
#
# GRD2CPT
# generates histogram equalized color pallette for
# topography data
#
# GRDIMAGE
# I option modulates the color image via illumination
