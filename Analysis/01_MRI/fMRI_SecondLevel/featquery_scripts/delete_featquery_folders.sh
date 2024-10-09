#!/bin/bash
SECOND_LEVEL_PATH='/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_SecondLevel/UNIVAR/IND_SPACE/BALANCED'

# to delete all previous featquery folders, run:
# 

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for subject in `cat $varname`; do

	for p in ${SECOND_LEVEL_PATH}/${subject}; do 

		ls ${p}/*.gfeat/cope*/left_*_*; ls -r ${p}/*.gfeat/cope*/right_*_* 
		rm -r ${p}/*.gfeat/cope*/left_*_*; rm -r ${p}/*.gfeat/cope*/right_*_* 

	done
done


