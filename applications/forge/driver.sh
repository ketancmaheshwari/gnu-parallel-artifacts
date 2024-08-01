#!/bin/bash

module load parallel

if [[ -z "${SLURM_NODEID}" ]]; then
    echo "need \$SLURM_NODEID set"
    exit
fi
if [[ -z "${SLURM_NNODES}" ]]; then
    echo "need \$SLURM_NNODES set"
    exit
fi

# Deliver tasks depending on the nodeid
#cat $1 |                                               \
find /lustre/orion/proj-shared/stf019/junqi-work/nvme-switch/data/945/67 -type f -iname '*.json' |                       \
awk -v NNODE="$SLURM_NNODES" -v NODEID="$SLURM_NODEID" \
'NR % NNODE == NODEID' |                               \
parallel -j128 ./payload.sh {}

