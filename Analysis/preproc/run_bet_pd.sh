#!/bin/sh

IN_PATH="../../Data/01_MRI/bids"
OUT_PATH="../../Results/01_MRI/BrainExtraction"

for participant in `cat subjects.txt`; do
	#/usr/local/fsl/bin/
	bet ${IN_PATH}/sub-${participant}/anat/sub-${participant}_acq-lowres_PDw ${OUT_PATH}/sub-${participant}_acq-lowres_PDw_brain  -f 0.45 -g -0.15
done