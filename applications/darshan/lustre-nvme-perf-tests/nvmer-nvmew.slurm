#!/bin/bash 
#SBATCH --mem=0 
#SBATCH -A STF019 
#SBATCH -t 4:00:00
#SBATCH -N 1 
#SBATCH -J archive-darshan
#SBATCH -o %j-std.out 
#SBATCH -e %j-std.err
#SBATCH -C nvme

module load cray-python/3.11.5
module load parallel
source /lustre/orion/proj-shared/stf019/Ahmad-Darshan/venv/bin/activate
mkdir -p /mnt/bb/ketan2/testoutdir/darshan_total
mkdir -p /mnt/bb/ketan2/summit_darshan_processed/
cd /lustre/orion/proj-shared/stf218/data/lake/summit_darshan_processed/ 
find 2021 -type f|parallel --tmpdir /mnt/bb/ketan2 -j32 -X rsync -R -Ha ./{} /mnt/bb/ketan2/summit_darshan_processed/
cd -

date +%s
parallel -j36 python3 /lustre/orion/stf019/proj-shared/Ahmad-Darshan/darshan_archival_storage_app_nvmerw.py ::: {1..12} ::: {0..2} 
date +%s

ls /mnt/bb/ketan2/testoutdir/
