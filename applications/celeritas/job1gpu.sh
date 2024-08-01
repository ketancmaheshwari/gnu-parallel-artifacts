#!/bin/bash
#SBATCH -A hep143
#SBATCH -J singlenode
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 30:00
#SBATCH -p batch
#SBATCH -N 1
#SBATCH -C nvme

source /lustre/orion/world-shared/hep143/olcfhelp-17955/celeritas/scripts/env/frontier.sh
module load parallel
export CELER_LOG=warning
export OMP_NUM_THREADS=7
cd /lustre/orion/proj-shared/stf008/ketan2/celeritas-run/celer-regression
date +%s
/lustre/orion/world-shared/hep143/celeritas/develop/bin/celer-sim 0.inp.json
date +%s

