#!/bin/bash

OUT_PATH='../../../Results/01_MRI/ANTS_REG'
hPD_PATH='../../../Data/01_MRI/bids'
ASHS_PATH='../../../Results/01_MRI/ASHS'

for i in `cat template_subjects.txt`; do

	mkdir ${OUT_PATH}/${i}
	## 1. Register MNI to hPD (we will use the inverse of this transformation)
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw.nii.gz \
	-m /usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz \
	-t s \
	-o ${OUT_PATH}/${i}/MNI2groupPD

done

## 2. Appy inverse transform to all ROI masks

for i in `cat template_subjects.txt`; do
	echo ${i}

	for mask in CA1 CA3DG SUB ERC PRC PHC;
	do
		for hemi in left right
		do
			antsApplyTransforms \
			-d 3 \
			-i ${ASHS_PATH}/${i}/masks/${i}_${hemi}_${mask}_mask.nii.gz \
			-r /usr/local/fsl/data/standard/MNI152_T1_1mm_brain.nii.gz \
			-t ${OUT_PATH}/${i}/MNI2groupPDInverseWarped.nii.gz \
		    -t [${OUT_PATH}/${i}/MNI2groupPD0GenericAffine.mat, 1] \
			-n GenericLabel \
		    -o ${OUT_PATH}/${i}/${i}_${hemi}_${mask}2MNI.nii.gz
		done
	done
done