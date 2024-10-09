#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG'
INPUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'

for i in `cat test_subjects.txt`; do

	mkdir ${OUT_PATH}/wbPD_to_MNI/${i}
	mkdir ${OUT_PATH}/T1_to_MNI/${i}

	##1. Register wbPD to T1 
	##Note: both should be brain extracted
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${INPUT_PATH}/sub-${i}_T1w_brain.nii.gz \
	-m ${INPUT_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t s \
	-o ${OUT_PATH}/wbPD_to_MNI/${i}/${i}_wbPD-To-T1_

	##2. Register T1 to MNI template
	#antsRegistrationSyNQuick.sh \
	#-d 3 \
	#-f ./MNI152_T1_1mm_brain.nii.gz \
	#-m ${INPUT_PATH}/sub-${i}_T1w_brain.nii.gz \
	#-t s \
	#-o ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_

	##3. Apply inverse transforms to MTL mask (MNI to wbPD)
	antsApplyTransforms \
	-d 3 \
	-i ./MNI_masks/mask_MTL.nii.gz \
	-o ${OUT_PATH}/wbPD_to_MNI/${i}/${i}_MTL_mask-To-wbPD.nii.gz \
	-n GenericLabel \
	-r ${INPUT_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t [${OUT_PATH}/wbPD_to_MNI/${i}/${i}_wbPD-To-T1_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/wbPD_to_MNI/${i}/${i}_wbPD-To-T1_1InverseWarp.nii.gz \
	-t [${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_1InverseWarp.nii.gz

	##4. Apply inverse transforms to MNI (reg to wb PD) for sanity checks
	antsApplyTransforms \
	-d 3 \
	-i ./MNI_masks/MNI152_T1_1mm_brain.nii.gz \
	-o ${OUT_PATH}/wbPD_to_MNI/${i}/${i}_MNI-To-wbPD.nii.gz \
	-r ${INPUT_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t [${OUT_PATH}/wbPD_to_MNI/${i}/${i}_wbPD-To-T1_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/wbPD_to_MNI/${i}/${i}_wbPD-To-T1_1InverseWarp.nii.gz \
	-t [${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_1InverseWarp.nii.gz

done



