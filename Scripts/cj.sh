#!/bin/sh

#perl  sra_shiny_redownload.pl > newestdata.txt | 
Rscript curationScript1.R 
perl taxID.pl > taxonData.txt 
Rscript curationScript2.R 
Rscript maps.R > ggmap.txt 
Rscript curationScript3.R
cp ShinyData.txt /srv/shiny-server/SRAexplorer/.


