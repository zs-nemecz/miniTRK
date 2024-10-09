#!/bin/sh

IN_PATH="../../Data/01_MRI/bids"
OUT_PATH="../../Results/01_MRI/fMRI_Preproc"

for participant in `cat subjects.txt`; do
	fslroi ${IN_PATH}/sub-${participant}/func/sub-${participant}_task-OBJ_acq-ENC_run-1_bold.nii.gz ${OUT_PATH}/sub-${participant}_task-OBJ_acq-ENC_run-1_bold_mid 125 1
	bet ${OUT_PATH}/sub-${participant}_task-OBJ_acq-ENC_run-1_bold_mid ${OUT_PATH}/sub-${participant}_task-OBJ_acq-ENC_run-1_bold_mid_brain
done