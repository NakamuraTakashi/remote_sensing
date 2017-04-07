#!/bin/bash
#cd ${PBS_O_WORKDIR}
cd /work1/t2gnakamulab/RS3
echo $ID
#
matlab -nodisplay -r "SU_main("$ID",50)"
