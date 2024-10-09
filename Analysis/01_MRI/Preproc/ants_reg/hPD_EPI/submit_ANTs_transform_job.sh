#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for subject in `cat $varname`; do
			echo ${subject}
        		# create empty design file for the current phase and run
        		currentjob="ANTs_trans_ROIs_to_meanFunc_${subject}.job"
        		echo ${currentjob}
        		# copy the full template script into the participant specific script
        		cp transform_ROIs_to_meanFunc_MPIB_template.job ${currentjob}
        		# edit the job file
        		sed -i "s|%SUBJ%|${subject}|g" $currentjob
			
			# some jobs failed preiosly because of out of memory error
			sbatch -p quick --mem 2GB --job-name transform_${subject} ${currentjob}
			rm $currentjob
done
