#!/bin/bash
#SBATCH -D /project/download_and_map
#SBATCH -J xaa
#SBATCH -o xaa-%j.out
#SBATCH -c 2
#SBATCH -p medium
#SBATCH --time=7-00:00:00
#SBATCH --mem=20G



source xaa
