#!/bin/sh

# template based on hPD_EPI/versionC-mask_ants_ROIs_to_meanFunc_2023-05-09.sh, originating from RegOptimization_2023-05-09 

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG/ROIs'
exampleFunc_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2023-06-21'
ASHS_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ASHS/MPIB_atlas/MPIB_corrected_truncated_segmentations'

################################################################################################
FIXED1='hPD'
MOVING1='T1'
FIXED2='T1'
MOVING2='meanFunc'

VERSION='C-mask'
REFERENCE=${exampleFunc_PATH}/%SUBJ%/%SUBJ%_task-OBJ_acq-ENC_run-1.feat/mean_func_corrected_brain.nii.gz
########################################################################################################

mkdir ${OUT_PATH}/%SUBJ%

# logging
echo MPIB TRUNCATED MASKS >> ${OUT_PATH}/%SUBJ%/%SUBJ%_log.txt

## Appy transforms on all ROI masks and PD for sanity check

for mask in CA1 DG SUB EC;
do
	for hemi in L R
	do
		### CHANGE TRANSFORMS IF NEEDED
		~/ANT/install/bin/antsApplyTransforms \
		-d 3 \
		-i ${ASHS_PATH}/%SUBJ%/%SUBJ%_${mask}${hemi}.nii.gz \
		-r ${REFERENCE} \
		-t [${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_0GenericAffine.mat, 1] \
		-t ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_${MOVING2}-To-${FIXED2}_1InverseWarp.nii.gz \
		-t [${OUT_PATH}/%SUBJ%/%SUBJ%_${MOVING1}-To-${FIXED1}_0GenericAffine.mat, 1] \
		-n GenericLabel \
		-o ${OUT_PATH}/%SUBJ%/${VERSION}_%SUBJ%_MPIB_${mask}${hemi}-To-${MOVING2}.nii.gz
		
	done
done

