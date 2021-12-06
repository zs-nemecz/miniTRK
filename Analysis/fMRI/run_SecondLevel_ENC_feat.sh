#!/bin/sh

OUT_PATH="../../Results/01_MRI/fMRI_SecondLevel"

for participant in `cat subjects.txt`; do
	echo ${participant} 
	mkdir ${OUT_PATH}/${participant}
	echo ${participant} ENC 2nd level >> log/ENC_feat_log.txt
	date >> log/ENC_feat_log.txt
	for task in OBJ LOC; do
			echo ${task} >> log/ENC_feat_log.txt
			
			currentdesign="Participant_${participant}_${task}_ENC.fsf"
			echo ${currentdesign} >> log/ENC_feat_log.txt
			# copy the full template ENCognition design file into the empty participant specific design file
			cp SecondLevel_ENC_template_design_file.fsf $currentdesign

			sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign	
			sed -i "s|%TASK%|${task}|g" $currentdesign

			feat $currentdesign 
			date >> log/ENC_feat_log.txt
	done
	echo ............................. >>  log/ENC_feat_log.txt
done