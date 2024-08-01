#!/bin/bash 
#SBATCH --mem=0 
#SBATCH -A STF019 
#SBATCH -t 2:00:00
#SBATCH -N 1 
#SBATCH -J archive-darshan
#SBATCH -o %j-std.out 
#SBATCH -e %j-std.err

module load cray-python/3.11.5
module load parallel
source /lustre/orion/proj-shared/stf019/Ahmad-Darshan/venv/bin/activate
date +%s
parallel -j36 python3 /lustre/orion/stf019/proj-shared/Ahmad-Darshan/darshan_archival_storage_app.py ::: {1..12} ::: {0..2} 
date +%s

