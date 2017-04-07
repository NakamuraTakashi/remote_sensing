#!/bin/bash
#cd ${PBS_O_WORKDIR}
cd /work1/t2gnakamulab/RS3
#
matlab -nodisplay -r "SU_main(48,50)"
#matlab -nodisplay -hostfile $PBS_NODEFILE -r SpectralUnmixing4T2
