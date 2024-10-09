#!/bin/bash

hPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
wbPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
T1_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'



echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

	#for each image, run:
	# 1. N4 bias field correction
	# 2. Brain Extraction (except for partial fov hPD)

	# 1. T1
	echo T1 ${i}
	T1="${T1_PATH}/sub-${i}_T1w"
	N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${T1}.nii.gz -o [ ${T1}_corrected.nii.gz, ${T1}_BiasField.nii.gz ]
	bet ${T1}_corrected.nii.gz ${T1}_corrected_brain -f 0.45 -g -0.15
	ls ${T1_PATH}/sub-${i}_T1w*
	echo ----------------------------------------
	echo
	
	
	# 2. hPD
	echo hPD ${i}
	hPD="${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw"
	N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${hPD}.nii.gz -o [ ${hPD}_corrected.nii.gz, ${hPD}_BiasField.nii.gz ]
	ls ${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw*
	echo ----------------------------------------
	echo
	
	# 3. wbPD
	echo wbPD ${i}
	wbPD="${wbPD_PATH}/sub-${i}/anat/sub-${i}_acq-lowres_PDw"
	N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${wbPD}.nii.gz -o [ ${wbPD}_corrected.nii.gz, ${wbPD}_BiasField.nii.gz ]
	bet ${wbPD}_corrected.nii.gz ${wbPD}_corrected_brain
	ls ${wbPD_PATH}/sub-${i}/anat/sub-${i}_acq-lowres_PDw*
	echo ----------------------------------------
	echo

done
	
	
	
