#!/bin/sh

# set directory for feat results
OUT_PATH="../../Results/01_MRI/fMRI_Preproc"

for participant in `cat subjects.txt`; do
	
	# print some info in the terminal and log file
	echo ${participant}

	# make a folder for the participants
	mkdir ${OUT_PATH}/${participant}

	for task in OBJ LOC; do
		for run in 1 2; do 
			# create empty design file for the current phase and run
			currentdesign="Preproc_${participant}_${task}_ENC_${run}.fsf"


			# copy the full template encoding design file into the empty participant specific design file
			cp Preproc_ENC_template_design_file.fsf $currentdesign
			# edit the design file
			sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign
			sed -i "s|%RUN%|${run}|g" $currentdesign	
			sed -i "s|%TASK%|${task}|g" $currentdesign

			# run feat and log the time and date when its finished
			time feat $currentdesign 
		done
	done
	echo .............................
done