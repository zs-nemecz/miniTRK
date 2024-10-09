#!/bin/bash

VERSION_OUT="UNIVAR/GROUP_SPACE/BALANCED"
TEMPLATE="ThirdLevel_ENC_UNIVAR_GROUP_SPACE_BALANCED.fsf"

for task in OBJ LOC; do

	echo ${task}
	echo ENC 3rd level
	for contrast in 1 2 3 4 5 6 7 8 9 10 11 12 13 14; do
		echo cope${contrast}

		currentdesign="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_ThirdLevel/${VERSION_OUT}/design_files/Contrast_${contrast}_${task}_ENC.fsf"
		echo ${currentdesign}
		# copy the full template ENCognition design file into the empty participant specific design file
		cp $TEMPLATE $currentdesign

		sed -i "s|%COPE_NUMBER%|${contrast}|g" $currentdesign
		sed -i "s|%TASK%|${task}|g" $currentdesign

		sbatch -p quick --mem 10GB --wrap ". /etc/profile ; module load fsl ; feat ${currentdesign}"
	done
	echo .............................
done
