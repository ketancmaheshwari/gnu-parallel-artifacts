#!/bin/bash

#SBATCH -A STF019
#SBATCH -J extractfromjson
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 1:00:00
#SBATCH -p batch
#SBATCH -N 4
#SBATCH --ntasks-per-node 1
#SBATCH -C nvme

srun --no-kill --ntasks-per-node=1 --wait=0 ./driver.sh ./input.txt

