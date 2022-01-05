#!/bin/sh

OUT_PATH="../../Results/01_MRI/fMRI_FirstLevel"

echo "Type subject list file:"

read varname

echo "Selected file $varname"


for participant in `cat ${varname}`; do
	echo ${participant}
	mkdir ${OUT_PATH}/${participant}
	echo ${participant} REC >> log/REC_feat_log.txt
	date >> log/REC_feat_log.txt
	for task in OBJ LOC; do
		for run in 1 2; do 
			echo ${task} ${run} >> log/REC_feat_log.txt

			currentdesign="Participant_${participant}_${task}_REC_${run}.fsf"
			foil_old="/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/02_APS_MRI_Logs/${participant}_${task}_FOIL_OLD_REC_run_${run}"
			echo ${currentdesign} >> log/REC_feat_log.txt
			# if [ -s ${foil_old}.txt ]; then
			# 	# the file is not empty, model Foil Old
			# 	# copy the full template RECoding design file into the empty participant specific design file
			# 	echo "${foil_old}.txt Not Empty" >> log/REC_feat_log.txt
			# 	cp FirstLevel_REC_template_design_file.fsf $currentdesign
			# else
			# 	# the file is empty, do not model Foil Old
			# 	echo "${foil_old}.txt Empty" >> log/REC_feat_log.txt
			# 	cp FirstLevel_REC_NO-FOIL-OLD-template_design_file.fsf $currentdesign
			# fi
			
			# leave TARGET New and FOIL OLD out for all participants and all runs
			cp FirstLevel_REC_NO-FOIL-OLD-template_design_file.fsf $currentdesign

			sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign
			sed -i "s|%RUN%|${run}|g" $currentdesign	
			sed -i "s|%TASK%|${task}|g" $currentdesign

			feat $currentdesign 
			date >> log/REC_feat_log.txt
		done
	done
	echo ............................. >>  log/REC_feat_log.txt
done