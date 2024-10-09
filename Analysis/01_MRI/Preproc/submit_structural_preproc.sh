#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for id in `cat $varname`; do

	export SUBJECT_ID=${id}
	sbatch -c 1 --mem 3GB t1_preproc.sh

done
	
	
	
