#!/bin/bash
# build template on Tardis

module load ants

inputPath=${PWD}
outputPath='/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/GroupTempl/PDw/'

${ANTSPATH}/antsMultivariateTemplateConstruction2.sh \
  -d 3 \
  -o ${outputPath}T_ \
  -i 4 \
  -g 0.2 \
  -j 8 \
  -c 5 \
  -q 100x100x70x20 \
  -n 1 \
  -r 1 \
  -l 1 \
  -t SyN \
  -m CC \
  ${inputPath}/POS*_PDw.nii.gz
