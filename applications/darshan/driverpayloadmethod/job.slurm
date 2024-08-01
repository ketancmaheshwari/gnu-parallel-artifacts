#!/bin/bash

#SBATCH -A STF019
#SBATCH -J darshan_process
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 2:00:00
#SBATCH -p batch
#SBATCH -N 2
#SBATCH --ntasks-per-node 1
#SBATCH -C nvme

### Lustre tuning, if needed
##export FI_CXI_DEFAULT_CQ_SIZE=13107200
##export FI_CXI_RX_MATCH_MODE=software
##export FI_MR_CACHE_MONITOR=memhooks

module load cray-python/3.11.5
module load parallel
source /lustre/orion/proj-shared/stf019/Ahmad-Darshan/venv/bin/activate

srun --no-kill --ntasks-per-node=1 --wait=0 ./driver.sh ./input.txt

