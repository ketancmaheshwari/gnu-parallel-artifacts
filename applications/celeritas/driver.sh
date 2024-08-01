#!/bin/bash

source /lustre/orion/world-shared/hep143/olcfhelp-17955/celeritas/scripts/env/frontier.sh
export OMP_NUM_THREADS=7
module load parallel

cd /lustre/orion/proj-shared/stf008/ketan2/celeritas-run/celer-regression
\ls {0..719}.inp.json | \
	awk -v NNODE="$SLURM_NNODES" -v NODEID="$SLURM_NODEID" \
	'NR % NNODE == NODEID' | \
	parallel -j8 HIP_VISIBLE_DEVICES='$(({%} - 1))' /lustre/orion/world-shared/hep143/celeritas/v0.4/bin/celer-sim {} ">" /lustre/orion/proj-shared/stf008/ketan2/{}.out

