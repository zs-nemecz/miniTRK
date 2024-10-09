#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for id in `cat $varname`; do
	for task in OBJ LOC; do
		for nrun in 1 2; do

			export SUBJECT_ID=${id}
			export TASK=${task}
   			export NRUN=${nrun}
			sbatch -p quick --mem 1GB --job-name BiasFieldCorr bias_field_correct_mean_func.job
		done
	done
done
