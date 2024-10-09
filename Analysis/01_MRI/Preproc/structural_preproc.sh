#!/bin/bash

module load fsl
module load ants

hPD_PATH='/home/mpib/nemecz/Projects/miniTRK/Data/01_MRI/bids'
wbPD_PATH='/home/mpib/nemecz/Projects/miniTRK/Data/01_MRI/bids'
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


# 2. hPD
echo hPD ${SUBJECT_ID} >> ${LOG_TXT}
hPD="${hPD_PATH}/sub-${SUBJECT_ID}/anat/sub-${SUBJECT_ID}_acq-highres_PDw"
N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${hPD}.nii.gz -o [ ${hPD}_corrected.nii.gz, ${hPD}_BiasField.nii.gz ]
ls ${hPD_PATH}/sub-${SUBJECT_ID}/anat/sub-${SUBJECT_ID}_acq-highres_PDw* >> ${LOG_TXT}


# 3. wbPD
echo wbPD ${SUBJECT_ID} >> ${LOG_TXT}
wbPD="${wbPD_PATH}/sub-${SUBJECT_ID}/anat/sub-${SUBJECT_ID}_acq-lowres_PDw"
N4BiasFieldCorrection -d 3 -s 4 -b [ 180 ] -i ${wbPD}.nii.gz -o [ ${wbPD}_corrected.nii.gz, ${wbPD}_BiasField.nii.gz ]
bet ${wbPD}_corrected.nii.gz ${wbPD}_corrected_brain
ls ${wbPD_PATH}/sub-${SUBJECT_ID}/anat/sub-${SUBJECT_ID}_acq-lowres_PDw* >> ${LOG_TXT}

	
	
	
