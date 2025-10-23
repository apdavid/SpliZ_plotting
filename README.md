# SpliZ Plotting

Contains code to plot significant genes from SpliZ output (https://github.com/salzman-lab/SpliZ)

## 10/23/25 update

Added mm10 GTF file and changed the figure output to PDF

## 9/25/25 update

First: run `run_prioritize.sh` (need to point to your SpliZ sites file)

Then, run `run_plot.sbatch` (point to file created by previous step; make sure folders exist)

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

We will run `make_plotter.py` using `run_plotter.sbatch`. 

Edit the following lines in `run_plotter.sbatch`:

* Set the `outpath` value to the folder you want the plotter file to be created in
* Set the `summary_file` value to the path of the summary file from your SpliZ output (the file in the top-level SpliZ output directory with a name starting with `summary`)

Then run the script: `bash run_plotter.sbatch` (note: you can run with bash because this should be a lightweight script).

A file called `plotter.txt` should be created in your `outpath` directory.


### Method 3: Manually create the file

If you know what genes and 3' or 5' splice sites you want to plot, you can create your own file following the format above.

## Running `make_boxplots.py`

To run `make_boxplots.py`, we need to edit `run_plot.sbatch`. 

Edit the following lines in `run_plot.sbatch`:

* `grouping_level_1`: Same as for SpliZ
* `grouping_level_2`: Same as for SpliZ
* `dataname`: Same as for SpliZ
* `suffix`: The suffix on your SpliZ output files (depends on which SpliZ input parameters you had). For example, if your SpliZ summary file is called `summary_ad_synapse_all_bounds0_lanemerge_status-broad.cell.type_S_0.01_z_0.0_b_0_SICILIAN.tsv`, your suffix is `_S_0.01_z_0.0_b_0_SICILIAN`
* `outdir`: The SpliZ output directory (the summary file should be a top-level file in this directory)
* `outpath`: Path to the directory you want to save images to (end with `/`)
* `plotterFile`: The path to the plotter file you want to use
* `gtf_file`: Path to the gtf file used for SpliZ

The remaining paths should be correctly defined with these inputs.

Run the file using `bash run_plot.sbatch` (if you don't have that many genes to plot), or `sbatch run_plot.sbatch` (if you have many genes to plot).

## Output

Output should be created in the `outpath` directory. For each gene and 3' or 5' end, there should be a boxplot, dotplot, and annotation plot. There is also a tsv with the exact coordinates of the annotation plot, and a csv that maps the `ont_num` from the dot plot y axis to the name of the ontology.

You can see examples of these plots in the `example_output` folder.
