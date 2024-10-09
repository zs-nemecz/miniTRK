#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG'
T1_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'

for i in `cat mtl_mask_subjects.txt`; do

	#mkdir ${OUT_PATH}/T1_to_MNI/${i}
	
	## 1. Register T1 to MNI template 
	#antsRegistrationSyNQuick.sh \
	#-d 3 \
	#-f ./MNI152_T1_1mm_brain.nii.gz \
	#-m ${T1_PATH}/sub-${i}_T1w_corrected_brain.nii.gz \
	#-t s \
	#-o ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_
	
	## Apply inverse transforms to MTL masks 
	for m in `cat mask_list.txt`; do
		antsApplyTransforms \
		-d 3 \
		-i ./${m}.nii.gz \
		-o ${OUT_PATH}/T1_to_MNI/${i}/${i}_${m}-To-T1.nii.gz \
		-n GenericLabel \
		-r ${T1_PATH}/sub-${i}_T1w_brain.nii.gz \
		-t [${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_0GenericAffine.mat, 1] \
		-t ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_1InverseWarp.nii.gz
	done 


done



