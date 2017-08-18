#MSc Bioinformatics Project
##SRAexplorer: A tool for visualizing and exploring the data on NCBI's Sequence Read Archive

(scripts can be found in SRAexplorer folder)

**Four Steps:**
  **1.** Gather metadata from SRA. -sra_parse.pl
  **2.** Weekly download of the latest submissions to SRA. -sra_weekly.pl & SRAexplorer_weekly.sh
  **3.** Curate the metadata for the application. -dataCuration.R, fetchGeocode.R, fetchTaxID.pl & dataMerge.R
  **4.** Create an interactive application to visualise the data. -server.R & -ui.R
  
  

