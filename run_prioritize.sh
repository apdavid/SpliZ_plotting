#!/bin/bash
#SBATCH --job-name=prioritize_plot
#SBATCH --output=../logs/prioritize_plot_%j.out
#SBATCH --error=../logs/prioritize_plot_%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=8G
#SBATCH --cpus-per-task=2

# Define arguments
#NAME="GSE168901_E16"
#GROUP1=experiment
#GROUP2=partition_cell_type_new

NAME="GSE137299_HC_low_res"
OUTPATH=${NAME}
GROUP1=dummy
GROUP2=timepoint
CUTOFF=0.25
PLOTTERFILE=/data/l2_jan_lab/projects/ear_spliz/results/${NAME}/SpliZ_sites/first_evec_${NAME}_pvals_${GROUP2}-${GROUP1}_100_S_0.1_z_0.0_b_5_r_0.01.tsv
SVD=/data/l2_jan_lab/projects/ear_spliz/results/${NAME}/SpliZ_values/${NAME}_sym_SVD_normdonor_S_0.1_z_0.0_b_5_r_0.01.pq

# Run the script
python prioritize_plotting.py \
    --outpath "$OUTPATH" \
    --plotterFile "$PLOTTERFILE" \
    --svd "$SVD" \
    --grouping_level_1 "$GROUP1" \
    --grouping_level_2 "$GROUP2" \
    --cutoff "$CUTOFF"
