#!/bin/bash

#SBATCH -A STF053
#SBATCH -J 2000nodes_128j
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 4:00:00
#SBATCH -p batch
#SBATCH -N 2000
#SBATCH --ntasks-per-node 1

###SBATCH -C nvme

export FI_CXI_DEFAULT_CQ_SIZE=13107200
export FI_CXI_RX_MATCH_MODE=software
export FI_MR_CACHE_MONITOR=memhooks

srun --no-kill --ntasks-per-node=1 --wait=0 ./driver.sh ./input.txt > /tmp/out.txt

cat /tmp/out.txt

