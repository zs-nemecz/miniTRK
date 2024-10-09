#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/timecourse'
filtered_func_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc'
roi_mask_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG'

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do
	
	mkdir ${OUT_PATH}/${i}

	for trial in OBJ LOC 
	do

		for type in ENC REC 
		do

			for run in 1 2 
			do

				for hemi in left right 
				do

					fslmeants \
					-i ${filtered_func_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/filtered_func_data.nii.gz \
					-o ${OUT_PATH}/${i}/${i}_${hemi}_OBJ_ENC_1_timecourse \
					-m ${roi_mask_PATH}/${trial}_${type}_run${run}/${i}/${i}_${hemi}_CA3DG-To-exampleFunc.nii.gz 
				
				done

			done

		done

	done

done
