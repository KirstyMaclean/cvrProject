#!/bin/sh

#PBS -l walltime=1:00:00
#PBS -l cput=1:00:00
#PBS -l nodes=1
#PBS -m abe
#PBS -M 2023085M@student.gla.ac.uk

perl  sra_shiny_redownload.pl > newestdata.txt | r curationScript.R
