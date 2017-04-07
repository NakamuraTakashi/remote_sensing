#!/bin/bash
# How to use?
# ./job_SUv3.sh [number]
# cf. ./job_SUv3.sh 17

#JOB_NAME="test_"$i
JOB_NAME="SU_"$1

#env ID=$i t2sub -q S -N $JOB_NAME -l select=1:ncpus=12:mpiprocs=12:mem=50gb -l place=scatter -l walltime=00:59:00 -et 0  -p 0 -W group_list=t2gnakamulab -V ./run_SUv2.sh 
env ID=$1 t2sub -q S -N $JOB_NAME -l select=1:ncpus=12:mpiprocs=12:mem=50gb -l place=scatter -l walltime=00:20:00 -et 0  -p 1 -W group_list=t2gnakamulab -V ./run_SUv2.sh 

