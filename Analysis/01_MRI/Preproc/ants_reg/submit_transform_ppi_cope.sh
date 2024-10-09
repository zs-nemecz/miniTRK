#!/bin/bash

for s in left_middle_frontal right_middle_frontal; do 

for task in LOC OBJ ;
do
	for cope in 1 2 3 4 5 6 7 8 9 10;
		do
		# create empty design file for the current phase and run
		jobfile="${task}_${s}${cope}-to-MNI.job"

		echo ${jobfile}
		# copy the full template encoding design file into the empty participant specific design file
		cp transform_ppi_cope-to-MNI.job ${jobfile}
		# edit the design file
		sed -i "s|%COPE_NUMBER%|${cope}|g" ${jobfile}
		sed -i "s|%TASK%|${task}|g" ${jobfile}
		sed -i "s|%SEED%|${s}|g" ${jobfile}
		sbatch -p quick --mem 1GB $jobfile
		rm $jobfile
	done
done
done
