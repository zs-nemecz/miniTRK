#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for hemi in left right; do
	for mask in CA1 CA3DG SUB ERC; do
		for task in OBJ LOC; do
			for subject in `cat $varname`; do
				echo ${task} ${subject} ${mask} ${hemi}

				currentjob="featquery_${subject}_ENC_${task}_${mask}_${hemi}.job"

				echo ${currentjob}
				# copy the full template ENC design file into the empty participant specific design file
				cp MPIB_PARAMETRIC_IND_SPACE_UNIVAR_ENC_featquery.job $currentjob

				sed -i "s|%SUBJ%|${subject}|g" $currentjob
				sed -i "s|%TASK%|${task}|g" $currentjob
				sed -i "s|%HEMI%|${hemi}|g" $currentjob
				sed -i "s|%MASK%|${mask}|g" $currentjob

				sbatch -p quick --job-name fquery_${hemi}_${mask}_${task}_${subject} --mem 500MB $currentjob
				rm $currentjob

			done #subject
		done #task
		sleep 2m
	done # mask
done # hemi
