#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG'
T1_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2022-10-07'

for i in `cat test_subjects.txt`; do

	mkdir ${OUT_PATH}/exampleFunc_to_MNI/${i}
	#mkdir ${OUT_PATH}/T1_to_MNI/${i}

	##1. Register EPI to T1 
	##Note: EPI should be brain extracted
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${T1_PATH}/sub-${i}_T1w_brain.nii.gz \
	-m ${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/example_func_brain.nii.gz \
	-t s \
	-o ${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_exampleFunc-To-T1_

	##2. Register T1 to MNI template
	#antsRegistrationSyNQuick.sh \
	#-d 3 \
	#-f ./MNI152_T1_1mm_brain.nii.gz \
	#-m ${T1_PATH}/sub-${i}_T1w_brain.nii.gz \
	#-t s \
	#-o ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_

	##3. Apply inverse transforms to MTL mask (MNI to EPI)
	antsApplyTransforms \
	-d 3 \
	-i ./MNI_masks/DILmask_MTL.nii.gz \
	-o ${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_MTL_DILmask-To-exampleFunc.nii.gz \
	-n GenericLabel \
	-r ${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/example_func_brain.nii.gz \
	-t [${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_exampleFunc-To-T1_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_exampleFunc-To-T1_1InverseWarp.nii.gz \
	-t [${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_1InverseWarp.nii.gz

	##4. Apply inverse transforms to MNI (reg to example_func) for sanity checks
	antsApplyTransforms \
	-d 3 \
	-i ./MNI_masks/MNI152_T1_1mm_brain.nii.gz \
	-o ${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_MNI-To-exampleFunc.nii.gz \
	-r ${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/example_func_brain.nii.gz \
	-t [${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_exampleFunc-To-T1_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/exampleFunc_to_MNI/${i}/${i}_exampleFunc-To-T1_1InverseWarp.nii.gz \
	-t [${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_0GenericAffine.mat, 1] \
	-t ${OUT_PATH}/T1_to_MNI/${i}/${i}_T1-To-MNI_1InverseWarp.nii.gz

done



