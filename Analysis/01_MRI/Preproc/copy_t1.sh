#!/bin/sh

IN_PATH="/home/mpib/nemecz/Projects/miniTRK/Data/01_MRI/bids"
OUT_PATH="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/BrainExtraction"

for participant in `cat all_subjects.txt`; do
	#/usr/local/fsl/bin/
	cp ${IN_PATH}/sub-${participant}/anat/sub-${participant}_T1w.nii.gz ${OUT_PATH}/
done
