#!/bin/bash
#SBATCH -A stf019
#SBATCH -J twonodes
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 1:00:00
#SBATCH -p batch
#SBATCH -N 2

srun --no-kill --ntasks-per-node=1 --wait=0 ./driver.sh

