#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do
    for task in OBJ LOC; do
        for nrun in 1 2; do

    	echo ${i}
    	# create empty design file for the current phase and run
    	currentjob="ANTs_reg_ROIs_to_meanFunc_${task}_${nrun}_${i}.job"
    	echo ${currentjob}
    	# copy the full template script into the participant specific script
    	cp ANTs_reg_ROIs_to_each_EPI.job ${currentjob}
    	# edit the design file
    	sed -i "s|%PARTICIPANT%|${i}|g" ${currentjob}
    	sed -i "s|%TASK%|${task}|g" ${currentjob}
   	sed -i "s|%NRUN%|${nrun}|g" ${currentjob}
    	sbatch -p short --mem 14GB --job-name ANTs_reg_ROIs_to_meanFunc_${i} ${currentjob}
    	rm ${currentjob}
	done
    done
done
