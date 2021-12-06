#!/bin/sh

OUT_PATH="../../Results/01_MRI/fMRI_FirstLevel"

for participant in `cat subjects.txt`; do
	echo ${participant}
	mkdir ${OUT_PATH}/${participant}
	echo ${participant} REC >> log/REC_feat_log.txt
	date >> log/REC_feat_log.txt
	for task in OBJ LOC; do
		for run in 1 2; do 
			echo ${task} ${run} >> log/REC_feat_log.txt

			currentdesign="Participant_${participant}_${task}_REC_${run}.fsf"
			echo ${currentdesign} >> log/REC_feat_log.txt
			# copy the full template RECoding design file into the empty participant specific design file
			cp FirstLevel_REC_template_design_file.fsf $currentdesign

			sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign
			sed -i "s|%RUN%|${run}|g" $currentdesign	
			sed -i "s|%TASK%|${task}|g" $currentdesign

			feat $currentdesign 
			date >> log/REC_feat_log.txt
		done
	done
	echo ............................. >>  log/REC_feat_log.txt
done