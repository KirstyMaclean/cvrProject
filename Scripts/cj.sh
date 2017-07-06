#!/bin/sh

perl  sra_shiny_redownload.pl > newestdata.txt | 
r curationScript1.R |
perl taxID.pl > taxonData.txt |
r curationScript2.R |
r maps.R > ggmap.txt |
r curationScript3.R



