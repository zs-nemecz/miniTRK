#!/bin/bash

OUT_VERSION='left_middle_frontal'
TEMPLATE='gPPI_ThirdLevel.fsf'

for task in OBJ LOC; do
	echo ${task}
	for contrast in 1 2 3 4 5 6 7 8 9 10 ; do
		echo cope${contrast}

		currentdesign="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/PPI/anatomical/${OUT_VERSION}/design_files/ThirdLevel_${task}_ENC_cope${contrast}.fsf"
		echo ${currentdesign}
		# copy the full template ENC design file into the empty participant specific design file
		cp $TEMPLATE $currentdesign

		sed -i "s|%TASK%|${task}|g" $currentdesign
		sed -i "s|%SEED%|${OUT_VERSION}|g" $currentdesign
		sed -i "s|%COPE_NUMBER%|${contrast}|g" $currentdesign

		#submit job
		# sbatch -p test --mem 5GB --job-name ppi_secondlevel --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"
		sbatch -p quick --mem 12GB --job-name ppi_thirdlevel --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"
	done
done
