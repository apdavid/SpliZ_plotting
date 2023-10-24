import argparse
import pandas as pd

def get_args():
  parser = argparse.ArgumentParser(description="get plotter file for significant genes")
  parser.add_argument("--outpath",help="path to save plotter file")
  parser.add_argument("--summary_file",help="path to summary file from SpliZ output")
  args = parser.parse_args()
  return args


def main():
  args = get_args()
  summ = pd.read_csv(args.summary_file, sep = "\t")

  genes = set()
  out = {"gene" : [], "end" : []}
  for gene, gene_df in summ.groupby("gene"):
      
      if (len(gene_df["scZ_median"].unique()) > 1) and (gene_df["scZ_pval"].min() < 0.05):
          spliz_sites = gene_df["SpliZsites"].iloc[0].split(",")
          for site in spliz_sites:
              out["gene"].append(gene)
              out["end"].append(site)
  pd.DataFrame.from_dict(out).to_csv("{}plotter.txt".format(args.outpath),index=False,sep="\t")

main()
