#!/bin/bash
#
#SBATCH --job-name=boxplot
#SBATCH --output=job_output/boxplot.%j.out
#SBATCH --error=job_output/boxplot.%j.err
#SBATCH --time=1:00:00
##SBATCH -p horence,owners
#SBATCH --nodes=1
##SBATCH --mem=60Gb

script_plot=make_boxplots.py

# REPLACE THESE VALUES WITH YOUR OWN
grouping_level_1=stage
grouping_level_2=organism
dataname=PRJNA930874
suffix=_S_0.01_z_0.0_b_5_SICILIAN
outdir=/exports/home/jolivieri/data/spliz/${dataname}/ 
outpath=/exports/home/jolivieri/spliz_boxplots/output/
plotterFile=test_plotter.txt
gtf_file=/exports/home/jolivieri/data/genomes/TAIR10/TAIR10_GFF3_genes.gtf


# THESE VALUES SHOULD STAY THE SAME
perm_pvals=${outdir}variance_adjusted_permutations/${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv
first_evec=${outdir}SpliZ_sites/first_evec_${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv 
first_evec=${outdir}SpliZ_sites/second_evec_${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv 
first_evec=${outdir}SpliZ_sites/third_evec_${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv 
splizvd_tsv=${outdir}SpliZ_values/${dataname}_sym_SVD_normdonor${suffix}_subcol.tsv
splizvd_pq=${outdir}SpliZ_values/${dataname}_sym_SVD_normdonor${suffix}.pq
outname=summary_${dataname}_${grouping_level_2}-${grouping_level_1}${suffix}.tsv 



python ${script_plot} \
    --plotterFile ${plotterFile} \
    --svd ${splizvd_pq} \
    --gtf_file ${gtf_file} \
    --dataname ${dataname} \
    --grouping_level_1 ${grouping_level_1} \
    --grouping_level_2 ${grouping_level_2} \
    --outpath ${outpath}

