import argparse
from collections import defaultdict
import matplotlib
#matplotlib.use('Agg') 

import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from matplotlib.patches import Patch

import pyarrow
import os
import pandas as pd
import seaborn as sns
from tqdm import tqdm
import warnings
warnings.filterwarnings("ignore")

def get_args():
    parser = argparse.ArgumentParser(description="prioritize positions for plotting/analysis based on avg rank diff")
    parser.add_argument("--outpath",help="path to save output")
    parser.add_argument("--plotterFile",help="file of parameters to make plots for")
    parser.add_argument("--svd",help="Input file")
    parser.add_argument("--grouping_level_1", default="dummy")
    parser.add_argument("--grouping_level_2", default="cell_type")
    parser.add_argument("--cutoff",type=float, help="only output rows with max diff > cutoff", default=0.5)
    args = parser.parse_args()
    return args

def main():
    args = get_args()

    df = pd.read_parquet(args.svd)

    plotterFile = pd.read_csv(args.plotterFile,sep="\t")

    pos_dict = {}
    for gene, gene_df in plotterFile.groupby("gene"):
        pos_dict[gene] = list(gene_df["end"].unique())
                
    let_dict = {"Start" : "acc", "End" : "don"}
    rev_dict = {"Start" : "End", "End" : "Start"}
    out_dict = {"gene" : [], "let" : [], "end" : [], "max_diff" : []}
    
    genes = list(pos_dict.keys())
    
    rank = 1
    for gene in tqdm(genes):

        rankLabel = "rank_" + str(rank)


        for let in ["Start", "End"]:

            gene_df = df[df["gene"] == gene]

            gene_df = gene_df[gene_df["junc{}".format(let)].isin(pos_dict[gene])]
                        
            # find number of splice partners for each splice site
            gene_df["num_" + let_dict[let]] = gene_df["pos{}_group".format(let)].map(gene_df.groupby("pos{}_group".format(let))["pos{}_group".format(rev_dict[let])].nunique())

            # only plot for those with more than one splice partner
            gene_df = gene_df[gene_df["num_" + let_dict[let]] > 1]

            gene_df["pos{}_cell".format(let)] = gene_df["pos{}_group".format(let)] + gene_df["cell"]

            # rank each splice partner
            gene_df["rank_{}".format(let_dict[let])] = gene_df.groupby("pos{}_group".format(let))["junc{}".format(rev_dict[let])].rank(method="dense")
                                                                                        
            # find sum of ranks of all reads for the cell
            gene_df["scaled_rank"] = gene_df["rank_" + let_dict[let]] * gene_df["numReads"]
            gene_df["num"] = gene_df["pos{}_cell".format(let)].map(gene_df.groupby("pos{}_cell".format(let))["scaled_rank"].sum())
            gene_df["denom"] = gene_df["pos{}_cell".format(let)].map(gene_df.groupby("pos{}_cell".format(let))["numReads"].sum())
            # calculate the average rank for the cell
            gene_df["avg_rank"] = gene_df["num"]/gene_df["denom"]
            for don, don_df in gene_df.groupby("pos{}_group".format(let)):
                don_df = don_df.drop_duplicates("pos{}_cell".format(let))
                vc = don_df.groupby(args.grouping_level_2)["avg_rank"].mean()
                out_dict["gene"].append(don_df["gene"].iloc[0])
                out_dict["let"].append(let)
                out_dict["end"].append(don_df["junc{}".format(let)].iloc[0])
                out_dict["max_diff"].append(vc.max() - vc.min())

    out_df = pd.DataFrame(out_dict).sort_values("max_diff",ascending=False)
    out_df = out_df[out_df["max_diff"] > args.cutoff]
    out_df.to_csv("{}_{}.tsv".format(args.outpath, args.cutoff),index=False,sep="\t")
main()
