#!/bin/sh

IN_PATH="../../Data/01_MRI/bids"
OUT_PATH="../../Results/fMRI_Preproc/fieldmaps/"

for participant in `cat subjects.txt`; do

	#copy each magnitude image from the run
	cp ${IN_PATH}/sub-${participant}/fmap/sub-${participant}_run-1_magnitude1.nii.gz ${OUT_PATH}/
	cp ${IN_PATH}/sub-${participant}/fmap/sub-${participant}_run-1_magnitude2.nii.gz ${OUT_PATH}/

	# average the magnitude images
	fslmaths sub-700822_run-1_magnitude1.nii.gz -add sub-700822_run-1_magnitude2.nii.gz sub-700822_run-1_magnitude_mean
	fslmaths sub-700822_run-1_magnitude_mean.nii.gz -div 2 sub-700822_run-1_magnitude_mean

	# bet the av. magnitude image
	bet ${OUT_PATH}/sub-${participant}_run-1_magnitude1.nii.gz ${OUT_PATH}/sub-${participant}_run-1_magnitude1_brain -f 0.7 -g -0.05

	# create fieldmap
	fsl_prepare_fieldmap SIEMENS sub-700822_run-1_phasediff.nii.gz sub-700822_run-1_magnitude_mean_brain.nii.gz sub-700822_run1_fmap 2.46
done