#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

	# create empty design file for the current phase and run
	jobfile="${i}_T1-to-MNI.job"

	echo ${jobfile}
	# copy the full template encoding design file into the empty participant specific design file
	cp ants_reg_T1-to-MNI.job ${jobfile}
	# edit the design file
	sed -i "s|%PARTICIPANT%|${i}|g" ${jobfile}
	
	sbatch -p quick --mem 4GB --job-name ants_T1-to-MNI $jobfile
	rm $jobfile

done
