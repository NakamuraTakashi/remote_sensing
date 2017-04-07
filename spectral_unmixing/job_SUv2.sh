#!/bin/bash
i=0
while [ $i -ne 50 ]
do
    i=`expr $i + 1`
    echo $i
    JOB_NAME="SU_"$i
    echo $JOB_NAME
    env ID=$i t2sub -q S -N $JOB_NAME -l select=1:ncpus=12:mpiprocs=12:mem=50gb -l place=scatter -l walltime=00:20:00 -et 0  -p 1 -W group_list=t2gnakamulab -V ./run_SUv2.sh 
done
