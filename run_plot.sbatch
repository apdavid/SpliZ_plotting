#!/bin/bash
#
#SBATCH --job-name=boxplot
#SBATCH --output=job_output/boxplot.%j.out
#SBATCH --error=job_output/boxplot.%j.err
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --mem=16Gb

script_plot=make_boxplots.py

# REPLACE THESE VALUES WITH YOUR OWN
#grouping_level_1=timepoint
#grouping_level_2=sctype_annotation
#dataname=GSE251854_e14_e16_full

#grouping_level_1=dummy
#grouping_level_2=sctype_annotation
#dataname=GSE137299_p7_full

grouping_level_1=dummy
grouping_level_2=timepoint
dataname=GSE137299_HC_low_res

#grouping_level_1=experiment
#grouping_level_2=partition_cell_type_new
#dataname=GSE168901_P7

suffix=_S_0.1_z_0.0_b_5_r_0.01
outdir=/data/l2_jan_lab/projects/ear_spliz/results/${dataname}/ 
outpath=/data/l2_jan_lab/projects/ear_spliz/results/plots/${dataname}/
#plotterFile=/data/l2_jan_lab/projects/ear_spliz/results/DIV3_rep2/SpliZ_sites/first_evec_DIV3_rep2_pvals_cell_type-dummy_100_S_0.1_z_0.0_b_5_r_0.01.tsv
plotterFile=/data/l2_jan_lab/projects/ear_spliz/src/${dataname}_0.25.tsv
gtf_file=/data/l2_jan_lab/projects/ear_spliz/raw_data/gencode.vM31.primary_assembly.annotation.gtf


# THESE VALUES SHOULD STAY THE SAME
perm_pvals=${outdir}variance_adjusted_permutations/${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv
first_evec=${outdir}SpliZ_sites/first_evec_${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv 
first_evec=${outdir}SpliZ_sites/second_evec_${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv 
first_evec=${outdir}SpliZ_sites/third_evec_${dataname}_pvals_${grouping_level_2}-${grouping_level_1}_100${suffix}.tsv 
splizvd_tsv=${outdir}SpliZ_values/${dataname}_sym_SVD_normdonor${suffix}_subcol.tsv
splizvd_pq=${outdir}SpliZ_values/${dataname}_sym_SVD_normdonor${suffix}.pq
outname=summary_${dataname}_${grouping_level_2}-${grouping_level_1}${suffix}.tsv 

mkdir -p ${outpath}dotplots/

echo $grouping_level_1
echo $grouping_level_2
echo $dataname



python ${script_plot} \
    --plotterFile ${plotterFile} \
    --svd ${splizvd_pq} \
    --gtf_file ${gtf_file} \
    --dataname ${dataname} \
    --grouping_level_1 ${grouping_level_1} \
    --grouping_level_2 ${grouping_level_2} \
    --outpath ${outpath}

