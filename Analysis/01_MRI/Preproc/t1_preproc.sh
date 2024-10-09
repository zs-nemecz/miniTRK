#!/bin/bash

module load fsl
module load ants

T1_PATH='/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/BrainExtraction'
LOG_TXT='/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/BrainExtraction/log.txt'


#for each image, run:
# 1. N4 bias field correction
# 2. Brain Extraction (except for partial fov hPD)

# 1. T1
echo T1 ${SUBJECT_ID} >> ${LOG_TXT}
T1="${T1_PATH}/sub-${SUBJECT_ID}_T1w"
N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${T1}.nii.gz -o [ ${T1}_corrected.nii.gz, ${T1}_BiasField.nii.gz ]
bet ${T1}_corrected.nii.gz ${T1}_corrected_brain -f 0.45 -g -0.15
ls ${T1_PATH}/sub-${SUBJECT_ID}_T1w* >> ${LOG_TXT}
