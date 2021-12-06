#!/bin/sh

OUT_PATH="../../Results/01_MRI/fMRI_ThirdLevel"

for task in OBJ LOC; do

	echo ${task} 
	echo ENC 3rd level >> log/ENC_feat_log.txt
	date >> log/ENC_feat_log.txt
	for contrast in 1 2 3 4 5 6 7 8 9 10 11 12 13; do
		echo cope${contrast} >> log/ENC_feat_log.txt
		
		currentdesign="Contrast_${contrast}_${task}_ENC.fsf"
		echo ${currentdesign} >> log/ENC_feat_log.txt
		# copy the full template ENCognition design file into the empty participant specific design file
		cp ThirdLevel_ENC_MASKED_template_design_file.fsf $currentdesign

		sed -i "s|%COPE%|${contrast}|g" $currentdesign	
		sed -i "s|%TASK%|${task}|g" $currentdesign

		feat $currentdesign 
		date >> log/ENC_feat_log.txt
	done
	echo ............................. >>  log/ENC_feat_log.txt
done