#!/bin/bash

hPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2023-06-21'
wbPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
T1_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'



echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

	#for each image, run:
	# 1. N4 bias field correction
	# 2. Brain Extraction (except for partial fov hPD, and mean_func, which is already brain extracted)

	# 1. EPI
	echo EPI ${i}
	EPI="${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/mean_func"
	N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${EPI}.nii.gz -o [ ${EPI}_corrected_brain.nii.gz, ${EPI}_BiasField.nii.gz ]
	ls ${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/mean_func*
	
	echo ----------------------------------------
	echo

done
	
	
	
