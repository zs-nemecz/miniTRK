#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"


for participant in `cat ${varname}`; do
	#for acq in ENC REC; do
		for task in OBJ LOC; do
			for nrun in 1 2; do

				currentjob="./${participant}_${task}_${nrun}.job"
				echo ${currentjob}

				# copy template design file into participant's design file
				cp extract_cortical_timecourses.job $currentjob

				sed -i "s|%PARTICIPANT%|${participant}|g" $currentjob
				sed -i "s|%TASK%|${task}|g" $currentjob
				sed -i "s|%ACQ%|ENC|g" $currentjob
				sed -i "s|%NRUN%|${nrun}|g" $currentjob

				sbatch -p short --mem 3GB $currentjob
				#rm $currentjob
			done
		done
	#done
	echo "submitted participant ${participant}"
done
