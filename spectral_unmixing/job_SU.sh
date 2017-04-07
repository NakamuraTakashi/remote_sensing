#
#t2sub -q S -N SU01 -l mem=50gb -l walltime=1:00:00 -et 1 -p 0 -W group_list=t2gnakamulab ./run_SU.sh
#t2sub -q S -N MAT-Y1 -l mem=10gb -l walltime=01:00:00 -et 1 -p 0 -W group_list=t2gnakamulab ./run_matlab.sh
#t2sub -q S -N SU04 -l select=4:ncpus=12:mpiprocs=12:mem=50gb -l place=scatter -l walltime=1:00:00 -et 1  -p 0 -W group_list=t2gnakamulab ./run_SU.sh
t2sub -q S -N SU48 -l select=1:ncpus=12:mpiprocs=12:mem=50gb -l place=scatter -l walltime=1:00:00 -et 1  -p 0 -W group_list=t2gnakamulab ./run_SU.sh

