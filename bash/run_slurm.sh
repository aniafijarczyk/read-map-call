#!/bin/bash
#SBATCH -D /project/download_and_map
#SBATCH -J test
#SBATCH -o test-%j.out
#SBATCH -c 2
#SBATCH -p medium
#SBATCH --time=7-00:00:00
#SBATCH --mem=20G



source run.sh SRR392813 CALB0456
