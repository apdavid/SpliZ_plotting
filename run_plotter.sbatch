#!/bin/bash
#
#SBATCH --job-name=plotter
#SBATCH --output=job_output/plotter.%j.out
#SBATCH --error=job_output/plotter.%j.err
#SBATCH --time=1:00:00
##SBATCH -p horence,owners
#SBATCH --nodes=1
##SBATCH --mem=60Gb

script_plot=make_plotter.py

outpath=/exports/home/jolivieri/spliz_boxplots/
summary_file=/exports/home/jolivieri/spliz_boxplots/summary_ad_synapse_all_bounds0_lanemerge_status-broad.cell.type_S_0.01_z_0.0_b_0_SICILIAN.tsv


python ${script_plot} \
    --outpath ${outpath} \
    --summary_file ${summary_file} 

