#!/bin/bash
#SBATCH -c 1
#SBATCH --mem=1000
#SBATCH -p cpu2019
#SBATCH -t 3-00:00
#SBATCH -o snakemake.out
#SBATCH -e snakemake.err
#SBATCH --mail-type=END
#SBATCH --mail-user=mortimer@hsph.harvard.edu

mkdir -p logs/slurm
snakemake --profile slurm
