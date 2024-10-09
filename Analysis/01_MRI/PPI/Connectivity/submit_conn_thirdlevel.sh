#!/bin/bash

TEMPLATE='OBJ_LOC_Connectivity_MASKED.fsf'

for seed in left_angular right_angular left_supramarginal right_supramarginal left_middle_frontal right_middle_frontal; do
	# print some info in the terminal
	echo ${seed}

	# create empty design file for the current task  and run
	currentdesign="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/PPI/connectivity/${seed}.fsf"

	echo ${currentdesign}
	# copy the full template encoding design file into the empty participant specific design file
	cp ${TEMPLATE} $currentdesign
	# edit the design file
	sed -i "s|%SEED%|${seed}|g" $currentdesign

	# submit job
	sbatch --mem 14GB --job-name fsl_conn --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"

done
