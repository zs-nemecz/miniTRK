#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG/LOC_REC_run2'
hPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc'
wbPD_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'
ASHS_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ASHS'


echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

	mkdir ${OUT_PATH}/${i}
	## 1. Register wbPD to hPD (we will use the inverse of this transformation)
	## with affine transformation
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw.nii.gz \
	-m ${wbPD_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t a \
	-o ${OUT_PATH}/${i}/wbPD-To-hPD

	## 2. Register wbPD to midFunc (resulting transorfmation matrix will be used as is)
	## Use Syn (non-linear) method. 
	## Note: only the affine transform matrix is used later, as this seems to work better. 
	antsRegistrationSyNQuick.sh \
	-d 3 \
	-f ${exampleFunc_PATH}/${i}/${i}_task-LOC_acq-REC_run-2.feat/example_func.nii.gz \
	-m ${wbPD_PATH}/sub-${i}_acq-lowres_PDw_brain.nii.gz \
	-t s \
	-o ${OUT_PATH}/${i}/wbPD-To-exampleFunc 

done


## 3. Appy transforms on all ROI masks

for i in `cat $varname`; do
	echo ${i}

	for mask in CA1 CA3DG SUB ERC PRC PHC CA2 CA3 DG BA35 BA36;
	do
		for hemi in left right
		do
			antsApplyTransforms \
			-d 3 \
			-i ${ASHS_PATH}/${i}/masks/${i}_${hemi}_${mask}_mask.nii.gz \
			-r ${exampleFunc_PATH}/${i}/${i}_task-LOC_acq-REC_run-2.feat/example_func.nii.gz \
		    -t ${OUT_PATH}/${i}/wbPD-To-hPD0GenericAffine.mat \
		    -t ${OUT_PATH}/${i}/wbPD-To-exampleFunc0GenericAffine.mat \
		    -n GenericLabel \
		   	-o ${OUT_PATH}/${i}/${i}_${hemi}_${mask}-To-exampleFunc_prob.nii.gz
		done
	done
done

#		s
