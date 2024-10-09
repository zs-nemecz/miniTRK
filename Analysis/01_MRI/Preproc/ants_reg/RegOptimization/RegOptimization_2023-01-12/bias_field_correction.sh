#!/bin/bash

hPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2022-10-07'
wbPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
T1_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'



echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

	#for each image, run:
	# 1. N4 bias field correction
	# 2. Brain Extraction (except for partial fov hPD)

	# 1. EPI
	echo EPI ${i}
	EPI="${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/example_func"
	N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${EPI}.nii.gz -o [ ${EPI}_corrected.nii.gz, ${EPI}_BiasField.nii.gz ]
	bet ${EPI}_corrected.nii.gz ${EPI}_corrected_brain
	ls ${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/example_func*
	
	echo ----------------------------------------
	echo
	
	# 2. T1
	echo T1 ${i}
	T1="${T1_PATH}/sub-${i}_T1w"
	#N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${T1}.nii.gz -o [ ${T1}_corrected.nii.gz, ${T1}_BiasField.nii.gz ]
	#bet ${T1}_corrected.nii.gz ${T1}_corrected_brain
	ls ${T1_PATH}/sub-${i}_T1w*
	echo ----------------------------------------
	echo
	
	
	# 3. hPD
	echo hPD ${i}
	hPD="${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw"
	#N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${hPD}.nii.gz -o [ ${hPD}_corrected.nii.gz, ${hPD}_BiasField.nii.gz ]
	#bet ${hPD}_corrected.nii.gz ${hPD}_corrected_brain
	ls ${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw*
	echo ----------------------------------------
	echo
	
	# 4. wbPD
	echo wbPD ${i}
	wbPD="${wbPD_PATH}/sub-${i}/anat/sub-${i}_acq-lowres_PDw"
	#N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${wbPD}.nii.gz -o [ ${wbPD}_corrected.nii.gz, ${wbPD}_BiasField.nii.gz ]
	#bet ${wbPD}_corrected.nii.gz ${wbPD}_corrected_brain
	ls ${wbPD_PATH}/sub-${i}/anat/sub-${i}_acq-lowres_PDw*
	echo ----------------------------------------
	echo

done
	
	
	
