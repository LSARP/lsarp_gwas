# lsarp_gwas

Description of GWAS pipeline developed for LSARP project. Pipeline scripts (but not data) are additionally tracked via git and backed up to a GitHub repository.  

## Pipeline Overview

This pipeline generates a table of unitigs (unique sequences that are present in > 1% of < 99% of the input genomes) that are significantly associated with a phenotype after controlling for population structure using a linear mixed model (LMM) implemented in the software pyseer. 

The general pipeline is as follows:

```
de novo assemblies -> annotations -> core genome alignment -> phylogeny -> similarity matrix
        |
        V
      unitigs

similiarity matrix + unitigs + phenotype -> LMM -> significant unitigs -> annotated unitigs -> phylogeny annotation
                                                                                   |
                                                                                   V        
                                                                            Manhattan plot

```
Details of the software used can be found by reading the Snakefile.

## Software Requirements

This pipeline is implemented in snakemake. Additionally, there are some helper scripts that are not packaged with pyseer via conda, so the pyseer git repository should be cloned to a software/ directory. Other required software is installed via conda as the pipeline runs. 

### conda

Miniconda3 can be installed from https://docs.conda.io/en/latest/miniconda.html.

### Snakemake

Snakemake can be installed via conda. Instructions here: https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

This pipeline uses a snakemake profile to interact with the slurm job submission system on ARC.

Template config file to be stored in `$HOME/.config/snakemake/slurm/config.yaml`:

```
restart-times: 3
cluster: "sbatch -t {resources.time} --nodes 1 --ntasks 1 --cpus-per-task {resources.cpus} --mem={resources.mem_mb} -o logs/slurm/{rule}_{wildcards}.out -e logs/slurm/{rule}_{wildcards}.err"
default-resources: [cpus=1, mem_mb=1000, time=60]
max-jobs-per-second: 1
max-status-checks-per-second: 10
local-cores: 1
use-conda: true
conda-prefix: /home/ARC_USERNAME/miniconda3/
jobs: 100
rerun-incomplete: true
```
### pyseer

The majority of pyseer components are installed via conda as part of the snakemake pipeline. However, the pipeline does require some helper scripts. To ensure the helper scripts can be found by the pipeline, run the following in the directory where you will be running the pipeline:

```
mkdir -p software/
cd software/
git clone https://github.com/mgalardini/pyseer.git
```

## Pipeline Components

### Snakefile

### start_snakemake.sh
Job submission script for running the pipeline (submit with `sbatch`).

### conda_envs/
Files describing conda environments for required pipeline software. 

### scripts/

#### fastbaps.R
Example script for running fastbaps to assign BAPS groups using an alignment and phylogeny as input. 
(Not currently used by GWAS pipeline)

#### filter_significant_unitigs.R
Gets the appropriate Bonferroni corrected significance threshold from pyseer output and filters pyseer unitig output.

#### get_mlst.py
Summarizes MLST output from pipeline results for all samples.
(Not currently used by GWAS pipeline)

## Input Details

### data/sequenced_isolates.txt
A tab-delimited list of sequenced isolates with batch numbers and alternate ids used in WGS data.

Format:
```
BATCH   WGS_ID                  ISOLATE_NBR
pilot   BI-16-0013_MOCUDI_3     BI_16_0013
pilot   BI-16-0017_MOCUDI_3     BI_16_0017
pilot   BI-16-0028_MOCUDI_3     BI_16_0028
```
### data/contaminated_isolates.txt
A list of WGS_IDs with evidence of contamination (will not be included in downstream analysis).

Format:
```
WGS_ID
BI_17_0054
BI-16-0629_MOCUDI_4
BI-16-0089_MOCUDI_3
```

### phenotype file
The file with phenotypic information for the GWAS. Binary phenotypes should be represented by 0 or 1. This file should be stored in `data/phenotype1/phenotype1.txt` (with the actual phenotype name, not the word "phenotype1")

Format:

```
WGS_ID                  BATCH   phenotype1
BI-16-0013_MOCUDI_3     pilot   1.36990875
BI-16-0017_MOCUDI_3     pilot   0.80548875
BI-16-0028_MOCUDI_3     pilot   1.11414875
```
### Directory Structure

```
GWAS_directory/
    Snakefile
    conda_envs/
    data/
        sequenced_isolates.txt
        contaminated_isolates.txt
        phenotype1/
            phenotype1.txt
    scripts/
    software/
        pyseer/

```

## Output Details

### unitigs

### annotations

### roary

### gubbins

### gwas output (directory named by phenotype)

## Interpretation of Significant Unitigs

