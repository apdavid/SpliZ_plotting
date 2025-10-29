#!/bin/bash
#SBATCH --job-name=prioritize_plot
#SBATCH --output=../logs/prioritize_plot_%j.out
#SBATCH --error=../logs/prioritize_plot_%j.err
#SBATCH --time=01:00:00
#SBATCH --mem=64G
#SBATCH --cpus-per-task=2

CONDA_ENV=nf-spliz-env
NAME=petipre_sgn_2022
OUTPATH=${NAME}
GROUP1=cell_type
GROUP2=developmental_age
CUTOFF=0.25
RESULTS_DIR=/data/l2_jan_lab/abel/SpliZ/results/${NAME}
PLOTTERFILE=${RESULTS_DIR}/SpliZ_sites/first_evec_${NAME}_pvals_${GROUP2}-${GROUP1}_100_S_0.1_z_0.0_b_5.tsv
SVD=${RESULTS_DIR}/SpliZ_values/${NAME}_sym_SVD_normdonor_S_0.1_z_0.0_b_5.pq

echo "----------------------------------------------"
echo "Data Name             : $NAME"
echo "Grouping Level 1      : $GROUP1"
echo "Grouping Level 2      : $GROUP2"
echo "Cutoff                : $CUTOFF"
echo "----------------------------------------------"

conda activate "$CONDA_ENV"

python prioritize_plotting.py \
    --outpath "$OUTPATH" \
    --plotterFile "$PLOTTERFILE" \
    --svd "$SVD" \
    --grouping_level_1 "$GROUP1" \
    --grouping_level_2 "$GROUP2" \
    --cutoff "$CUTOFF"