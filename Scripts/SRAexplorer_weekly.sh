#!/bin/sh

#script to run weekly on webserver using cron
current_time=$(date "+Y.%m.%d")
echo "Current Time : $current_time"

perl  sra_weekly.pl > newestdata.txt 
Rscript dataCuration.R 
echo 'curating data'
perl fetchTaxID.pl > taxonData.txt
echo 'accessing taxonomy database'  
Rscript fetchGeocode.R  
Rscript  mergeData.R
cp ShinyData.txt /srv/shiny-server/SRAexplorer/.
newfile="ShinyData".$current_time.".txt"
mv ShinyData.txt $newfile



