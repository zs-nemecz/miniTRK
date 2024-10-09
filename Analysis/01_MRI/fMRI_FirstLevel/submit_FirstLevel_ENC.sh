#!/bin/sh

TEMPLATE='FirstLevel_ENC_UNIVAR_GROUP_SPACE_BALANCED.fsf'
VERSION_OUT='UNIVAR/GROUP_SPACE/BALANCED'

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for participant in `cat $varname`; do
	# print some info in the terminal
	echo ${participant}

	for task in OBJ LOC; do
		for nrun in 1 2; do
			# create empty design file for the current task  and run
			currentdesign="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_FirstLevel/${VERSION_OUT}/design_files/FirstLevel_${participant}_${task}_ENC_${nrun}.fsf"

			echo ${currentdesign}
			# copy the full template encoding design file into the empty participant specific design file
			cp ${TEMPLATE} $currentdesign
			# edit the design file
			sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign
			sed -i "s|%RUN%|${nrun}|g" $currentdesign
			sed -i "s|%TASK%|${task}|g" $currentdesign
			sed -i "s|%ACQ%|ENC|g" $currentdesign

			# submit job
			sbatch --mem 10GB --job-name fsl_firstlevel_${participant}_${task}_${nrun} --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"

		done
	done
	echo .............................
done
