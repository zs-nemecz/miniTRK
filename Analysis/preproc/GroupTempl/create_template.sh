#!/bin/bash

DATA_PATH='../../../Data/01_MRI/bids'

for subj in `cat subjects.txt`
do
    cp ${DATA_PATH}/sub-${subj}/anat/sub-${subj}_acq-highres_PDw.nii.gz .
done

inputPath=${PWD}/
outputPath='/mnt/fmri_data/miniTRK/Results/01_MRI/GroupTempl/highres_PDw/'

${ANTSPATH}/antsMultivariateTemplateConstruction2.sh \
  -d 3 \
  -o ${outputPath}T_ \
  -i 4 \
  -g 0.2 \
  -j 4 \
  -c 2 \
  -f 8x4x2x1 \
  -s 3x2x1x0 \
  -q 100x100x70x10 \
  -n 1 \
  -r 1 \
  -l 1 \
  -t SyN \
  ${inputPath}/*_acq-highres_PDw.nii.gz
