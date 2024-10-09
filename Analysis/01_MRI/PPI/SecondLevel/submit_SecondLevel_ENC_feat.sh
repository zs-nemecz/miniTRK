#!/bin/sh

OUT_VERSION='left_middle_frontal'
TEMPLATE='gPPI_SecondLevel.fsf'

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for participant in `cat $varname`; do
	echo ${participant}

	for task in OBJ LOC; do
		echo ${task}

		currentdesign="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/PPI/anatomical/${OUT_VERSION}/design_files/SecondLevel_${participant}_${task}_ENC.fsf"
		echo ${currentdesign}
		# copy the full template ENC design file into the empty participant specific design file
		cp $TEMPLATE $currentdesign

		sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign
		sed -i "s|%TASK%|${task}|g" $currentdesign
		sed -i "s|%SEED%|${OUT_VERSION}|g" $currentdesign

		#submit job
	        #sbatch -p test --mem 5GB --job-name ppi_secondlevel --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"
		sbatch -p quick --mem 5GB --job-name ppi_secondlevel --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"

	done
	echo .............................
done
