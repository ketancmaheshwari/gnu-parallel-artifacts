#!/bin/bash
#SBATCH -A hep143
#SBATCH -J 90nodes
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 1:00:00
#SBATCH -p batch
#SBATCH -N 90

date +%s
srun --no-kill --ntasks-per-node=1 --wait=0 ./driver.sh
date +%s

