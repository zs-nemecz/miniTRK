#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG/ROIs/antsRegistrationSyn_2023-01-20'
hPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2022-10-07'
wbPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
ASHS_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ASHS'

###################################################################################################
## PARAMETERS TO CHANGE FOR EACH VERSION
FIXED1='hPD'
MOVING1='wbPD'
FIXED2='exampleFunc'
MOVING2='wbPD'

VERSION='A'
###################################################################################################

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

	########################################################################################################
	## PARAMETERS TO CHANGE FOR EACH VERSION
	FIXED_INPUT1=${hPD_PATH}/sub-${i}/anat/sub-${i}_acq-highres_PDw_corrected.nii.gz
	MOVING_INPUT1=${wbPD_PATH}/sub-${i}/anat/sub-${i}_acq-lowres_PDw_corrected_brain.nii.gz

	FIXED_INPUT2=${exampleFunc_PATH}/${i}/${i}_task-OBJ_acq-ENC_run-1.feat/example_func_corrected_brain.nii.gz
	MOVING_INPUT2=${wbPD_PATH}/sub-${i}/anat/sub-${i}_acq-lowres_PDw_corrected_brain.nii.gz
	########################################################################################################
	
        # print and check before continuing
        echo VERSION NAME: ${VERSION}
	echo --------------------------------------
	sleep 1
	echo FIXED1: ${FIXED1} = ${FIXED_INPUT1}
	echo MOVING1: ${MOVING1} =  ${MOVING_INPUT1}
	sleep 3
	echo --------------------------------------
	echo FIXED2: ${FIXED2} = ${FIXED_INPUT2}
	echo MOVING2: ${MOVING2} =  ${MOVING_INPUT2}
	sleep 20

	mkdir ${OUT_PATH}/${i}
	## 1. Register wbPD to hPD (we will use the inverse of this transformation)
	## with affine transformation
	antsRegistrationSyN.sh \
	-d 3 \
	-f ${FIXED_INPUT1} \
	-m ${MOVING_INPUT1} \
	-t a \
	-o ${OUT_PATH}/${i}/${i}_${MOVING1}-To-${FIXED1}_

	## 2. EPI
	## Use Syn (non-linear) method. 
	antsRegistrationSyN.sh \
	-d 3 \
	-f ${FIXED_INPUT2} \
	-m ${MOVING_INPUT2} \
	-t s \
	-o ${OUT_PATH}/${i}/${VERSION}_${i}_${MOVING2}-To-${FIXED2}_

	## 3. Appy transforms on all ROI masks and PD for sanity check
	echo ${i}
	### CHANGE TRANSFORMS IF NEEDED
	antsApplyTransforms \
	-d 3 \
	-i ${FIXED_INPUT1} \
	-r ${FIXED_INPUT2} \
	-t ${OUT_PATH}/${i}/${VERSION}_${i}_${MOVING2}-To-${FIXED2}_1Warp.nii.gz \
	-t ${OUT_PATH}/${i}/${VERSION}_${i}_${MOVING2}-To-${FIXED2}_0GenericAffine.mat \
	-t [${OUT_PATH}/${i}/${i}_${MOVING1}-To-${FIXED1}_0GenericAffine.mat, 1] \
	-o ${OUT_PATH}/${i}/${VERSION}_${i}_${FIXED1}-To-${FIXED2}.nii.gz

	for mask in CA1 CA3DG SUB ERC PRC PHC CA2 CA3 DG BA35 BA36;
	do
		for hemi in left right
		do
			### CHANGE TRANSFORMS IF NEEDED
			antsApplyTransforms \
			-d 3 \
			-i ${ASHS_PATH}/${i}/masks/${i}_${hemi}_${mask}_mask.nii.gz \
			-r ${FIXED_INPUT2} \
			-t ${OUT_PATH}/${i}/${VERSION}_${i}_${MOVING2}-To-${FIXED2}_1Warp.nii.gz \
			-t ${OUT_PATH}/${i}/${VERSION}_${i}_${MOVING2}-To-${FIXED2}_0GenericAffine.mat \
			-t [${OUT_PATH}/${i}/${i}_${MOVING1}-To-${FIXED1}_0GenericAffine.mat, 1] \
			-n GenericLabel \
			-o ${OUT_PATH}/${i}/${VERSION}_${i}_${hemi}_${mask}-To-${FIXED2}.nii.gz
			
		done
	done
done

