#!/bin/bash

module load cray-python/3.11.5
module load parallel
source /lustre/orion/proj-shared/stf019/Ahmad-Darshan/venv/bin/activate

cat stage1.in | parallel
cat stage2.in | parallel
cat stage3.in | parallel
cat stage4.in | parallel
cat stage5.in | parallel

