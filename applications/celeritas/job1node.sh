#!/bin/bash
#SBATCH -A hep143
#SBATCH -J singlenode
#SBATCH -o %x-%j.out
#SBATCH -e %x-%j.err
#SBATCH -t 0:20:00
#SBATCH -p batch
#SBATCH -N 1

source /lustre/orion/world-shared/hep143/olcfhelp-17955/celeritas/scripts/env/frontier.sh
module load parallel
#export CELER_LOG=warning
export OMP_NUM_THREADS=7
date +%s
cd /lustre/orion/proj-shared/stf008/ketan2/celeritas-run/celer-regression
\ls {0..7}.inp.json | parallel -j8 HIP_VISIBLE_DEVICES='$(({%} - 1))' /lustre/orion/world-shared/hep143/celeritas/v0.4/bin/celer-sim {} ">" /lustre/orion/proj-shared/stf008/ketan2/{}.out
date +%s

