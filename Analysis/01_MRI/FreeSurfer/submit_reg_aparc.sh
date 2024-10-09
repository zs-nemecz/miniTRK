#!/bin/bash

TEMPLATE="reg-aparc2feat.job"

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for participant in `cat $varname`; do
	# print some info in the terminal
	echo ${participant}

	for task in OBJ LOC; do
		for nrun in 1 2; do
			# create empty design file for the current task  and run
			currentjob="aparc_reg_${participant}_${task}_ENC_${nrun}.job"

			echo ${currentjob}
			# copy the full template encoding design file into the empty participant specific design file
			cp ${TEMPLATE} $currentjob
			# edit the design file
			sed -i "s|%PARTICIPANT%|${participant}|g" $currentjob
			sed -i "s|%NRUN%|${nrun}|g" $currentjob
			sed -i "s|%TASK%|${task}|g" $currentjob

			# submit job
			sbatch -p short --mem 4GB $currentjob

		done
	done
	echo .............................
done
