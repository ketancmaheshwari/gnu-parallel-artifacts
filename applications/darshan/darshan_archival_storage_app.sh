#!/bin/bash

IFS=,
months='1,2,3,4,5,6,7,8,9,10,11,12'
apps_lst='3'
months=($months)
apps_lst=($apps_lst)
counter=0
for month in ${months[@]}; do
    apps=${apps_lst[counter]}
    app=0 
    while [[ $app -lt ${apps} ]] ; do
        echo "Month: "${month} " App: " ${app}
	echo "srun -N1 -n1 -c1 --exclusive python3 /gpfs/alpine/proj-shared/stf218/25amk/darshan-ml/git/darshan-ml-modeling/code/darshan_archival_storage_app.py ${month} ${app} &"
	
	sleep 0.2
	((app++))
        done;
    done;
wait

