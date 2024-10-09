#!/bin/sh

IN_PATH="../../Data/01_MRI/bids"
OUT_PATH="../../Results/01_MRI/BrainExtraction"

for participant in `cat subjects.txt`; do
	#/usr/local/fsl/bin/
	bet ${IN_PATH}/sub-${participant}/anat/sub-${participant}_T1w ${OUT_PATH}/sub-${participant}_T1w_brain  -f 0.45 -g -0.15
done