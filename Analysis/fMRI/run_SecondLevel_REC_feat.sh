#!/bin/sh

OUT_PATH="../../Results/01_MRI/fMRI_SecondLevel"

for participant in `cat subjects.txt`; do
	echo ${participant} 
	mkdir ${OUT_PATH}/${participant}
	echo ${participant} REC 2nd Level>> log/REC_feat_log.txt
	date >> log/REC_feat_log.txt
	for task in OBJ LOC; do
			echo ${task} >> log/REC_feat_log.txt
			
			currentdesign="Participant_${participant}_${task}_REC.fsf"
			echo ${currentdesign} >> log/REC_feat_log.txt
			# copy the full template recognition design file into the empty participant specific design file
			cp SecondLevel_REC_template_design_file.fsf $currentdesign

			sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign	
			sed -i "s|%TASK%|${task}|g" $currentdesign

			feat $currentdesign 
			date >> log/REC_feat_log.txt
		done
	done
	echo ............................. >>  log/REC_feat_log.txt
done