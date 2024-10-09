#!/bin/sh

# template based on hPD_EPI/versionC-mask_ants_ROIs_to_meanFunc_2023-05-09.sh, originating from RegOptimization_2023-05-09 

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG/ROIs'
hPD_PATH='/mnt/fmri_data/miniTRK/Data/01_MRI/bids'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2023-06-21'
T1_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/BrainExtraction'
ASHS_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ASHS/UPENN_in_use'

###################################################################################################
## PARAMETERS TO CHANGE FOR EACH VERSION
FIXED1='hPD'
MOVING1='T1'
FIXED2='T1'
MOVING2='meanFunc'

MASK_PATH=/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG/${FIXED2}_To_MNI

VERSION='C-mask'
###################################################################################################


########################################################################################################
## PARAMETERS TO CHANGE FOR EACH VERSION
FIXED_INPUT1=${hPD_PATH}/sub-%SUBJ%/anat/sub-%SUBJ%_acq-highres_PDw_corrected.nii.gz
MOVING_INPUT1=${T1_PATH}/sub-%SUBJ%_T1w_corrected_brain.nii.gz

FIXED_INPUT2=${T1_PATH}/sub-%SUBJ%_T1w_corrected_brain.nii.gz
MOVING_INPUT2=${exampleFunc_PATH}/%SUBJ%/%SUBJ%_task-OBJ_acq-ENC_run-1.feat/mean_func_corrected_brain.nii.gz
MASK_INPUT=${MASK_PATH}/%SUBJ%/%SUBJ%_MTL_mask-To-${FIXED2}.nii.gz
########################################################################################################

mkdir ${OUT_PATH}/%SUBJ%

# logging
echo VERSION NAME: ${VERSION} > ${OUT_PATH}/%SUBJ%/%SUBJ%_log.txt
echo -------------------------------------- >> ${OUT_PATH}/log/%SUBJ%_log.txt

echo FIXED1: ${FIXED1} = ${FIXED_INPUT1} >> ${OUT_PATH}/log/%SUBJ%_log.txt
echo MOVING1: ${MOVING1} =  ${MOVING_INPUT1} >> ${OUT_PATH}/log/%SUBJ%_log.txt

echo -------------------------------------- >> ${OUT_PATH}/log/%SUBJ%_log.txt
echo FIXED2: ${FIXED2} = ${FIXED_INPUT2} >> ${OUT_PATH}/log/%SUBJ%_log.txt
echo MOVING2: ${MOVING2} =  ${MOVING_INPUT2} >> ${OUT_PATH}/log/%SUBJ%_log.txt
echo MASK: ${MASK_INPUT} >> ${OUT_PATH}/log/%SUBJ%_log.txt

## 1. Register T1 to hPD (we will use the inverse of this transformation)
## with affine transformation
antsRegistrationSyN.sh -d 3 -f ${FIXED_INPUT1} -m ${MOVING_INPUT1} -t a -o ${OUT_PATH}/%SUBJ%/%SUBJ%_${MOVING1}-To-${FIXED1}_

## 2. EPI
## Rigid then Syn

antsRegistration \
--dimensionality 3 \
--float 0 \
--output [${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_, ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_Warped.nii.gz] \
--interpolation Linear --winsorize-image-intensities [0.005,0.995] \
--use-histogram-matching 0 \
--initial-moving-transform [${FIXED_INPUT2},${MOVING_INPUT2},1] \
--transform Rigid[0.1] \
--metric MI[${FIXED_INPUT2},${MOVING_INPUT2},1,32,Regular,0.20] \
--convergence [1000x500x100x0,1e-6,10] \
--shrink-factors 8x4x2x1 \
--smoothing-sigmas 3x2x1x0vox \
--transform SyN[0.1,3,0] \
--restrict-deformation 1x1x0 \
--metric CC[${FIXED_INPUT2},${MOVING_INPUT2},1,4] \
--convergence [10,1e-6,10] \
--shrink-factors 1 \
--smoothing-sigmas 0vox  \
--x ${MASK_INPUT} \
--verbose


## 3. Appy transforms on all ROI masks and PD for sanity check

### CHANGE TRANSFORMS IF NEEDED
antsApplyTransforms \
-d 3 \
-i ${FIXED_INPUT1} \
-r ${MOVING_INPUT2} \
-t [${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_0GenericAffine.mat, 1] \
-t ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_1InverseWarp.nii.gz \
-t [${OUT_PATH}/%SUBJ%/%SUBJ%_${MOVING1}-To-${FIXED1}_0GenericAffine.mat, 1] \
-o ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${FIXED1}-To-${MOVING2}.nii.gz

for mask in CA1 CA3DG SUB ERC PRC PHC CA2 CA3 DG BA35 BA36;
do
	for hemi in left right
	do
		### CHANGE TRANSFORMS IF NEEDED
		antsApplyTransforms \
		-d 3 \
		-i ${ASHS_PATH}/%SUBJ%/%SUBJ%_${hemi}_${mask}_mask.nii.gz \
		-r ${MOVING_INPUT2} \
		-t [${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_0GenericAffine.mat, 1] \
		-t ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_1InverseWarp.nii.gz \
		-t [${OUT_PATH}/%SUBJ%/%SUBJ%_${MOVING1}-To-${FIXED1}_0GenericAffine.mat, 1] \
		-n GenericLabel \
		-o ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${hemi}_${mask}-To-${MOVING2}.nii.gz
		
	done
done

