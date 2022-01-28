#!/bin/bash

OUT_PATH='../../../Results/01_MRI/ANTS_REG'
hPD_PATH='../../../Data/01_MRI/bids'
midFunc_PATH='../../../Results/01_MRI/fMRI_Preproc'
wbPD_PATH='../../../Results/01_MRI/BrainExtraction'
ASHS_PATH='../../../Results/01_MRI/ASHS'

for i in `cat subjects.txt`; do

	mkdir ${OUT_PATH}/${i}
	## 1. Register wbPD to hPD (we will use the inverse of this transformation)
	## with affine transformation
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw.nii.gz \
	-m ${wbPD_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t a \
	-o ${OUT_PATH}/${i}/wbPD2hPD

	## 2. Register wbPD to midFunc (resulting transorfmation matrix will be used as is)
	## Use Syn (non-linear) method. 
	## Note: only the affine transform matrix is used later, as this seems to work better. 
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${midFunc_PATH}/sub-${i}_task-OBJ_acq-ENC_run-1_bold_mid_brain.nii.gz \
	-m ${wbPD_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t s \
	-o ${OUT_PATH}/${i}/wbPD2midFunc

done

## 3. Appy transforms on all ROI masks

for i in `cat subjects.txt`; do
	echo ${i}

	for mask in CA1 CA3DG SUB ERC PRC PHC;
	do
		for hemi in left right
		do
			antsApplyTransforms \
			-d 3 \
			-i ${ASHS_PATH}/${i}/masks/${i}_${hemi}_${mask}_mask.nii.gz \
			-r ${midFunc_PATH}/sub-${i}_task-OBJ_acq-ENC_run-1_bold_mid_brain.nii.gz \
		    -t [${OUT_PATH}/${i}/wbPD2hPD0GenericAffine.mat, 1] \
			-t ${OUT_PATH}/${i}/wbPD2midFunc0GenericAffine.mat \
			-n GenericLabel \
		    -o ${OUT_PATH}/${i}/${i}_${hemi}_${mask}2midFunc.nii.gz
		done
	done
done