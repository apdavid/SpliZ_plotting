# SpliZ Plotting

Contains code to plot significant genes from SpliZ output (https://github.com/salzman-lab/SpliZ)

## Create conda environment

This code requires the following dependencies: `matplotlib`, `pyarrow`, `matplotlib`, `os`, `pandas`, `seaborn`, `tqdm`, `warnings`. 

Either install those packages yourself, or use the `environment.yml` file included in the repository:

```
conda env create -f environment.yml
```

Activate the environment:

```
conda activate boxplots
```

## Creating the plotter file

This script requires a plotter file as input, which specifies which genes, and which 3' or 5' splice sites, you want to plot.

This is a tab-separated file with columnds `gene` and `end` (additional columns will be ignored). The `gene` column contains the gene name, and `end` contains the 3' or 5' end, you want to plot. You can include as many rows as you would like to plot.

For example:

```
gene	end
AT1G65980	24559777
AT1G65980	24557780
AT1G65980	24560311
AT2G41430	17269720
AT2G41430	17269402
AT2G41430	17269509
AT3G60540	22375825
AT3G60540	22375402
AT3G60540	22375703
```

There are three ways you can create this file.


### Method 1: Use one of the files in the `SpliZ_sites` directory

You should have a `SpliZ_sites` directory in your output, which will have files `first_evec*.tsv`, `second_evec*.tsv`, and `third_evec*.tsv`. All of these files are in the right format already. They contain genes and "ends" that have been computationally identified to be variable. There will usually be a lot of overlap between these files. You can run for just one of these files, or all of them.

### Method 2: Create the plotter file with `make_plotter.py`

In this method, the plotter file will be created based on the summary output file.


