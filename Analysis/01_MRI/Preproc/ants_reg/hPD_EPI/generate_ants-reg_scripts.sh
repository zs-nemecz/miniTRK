#!/bin/bash

OUT_PATH='/mnt/fmri_data/miniTRK/Results/01_MRI/ANTS_REG/ROIs/scripts'


echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

    echo ${i}
    
    # create empty design file for the current phase and run
	currentscript="${OUT_PATH}/transform_MPIB_masks_${i}.sh"

	echo ${currentscript}
	# copy the full template script into the participant specific script
	cp transform_ROIs_to_meanFunc_MPIB_template_script.sh ${currentscript}
	# edit the design file
	sed -i "s|%SUBJ%|${i}|g" ${currentscript}
	
done

