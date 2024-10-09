#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

    echo ${i}
    # create empty design file for the current phase and run
    currentjob="ANTs_reg_ROIs_to_meanFunc_${i}.job"
    echo ${currentjob}
    # copy the full template script into the participant specific script
    cp ANTs_reg_ROIs_to_meanFunc.job ${currentjob}
    # edit the design file
    sed -i "s|%PARTICIPANT%|${i}|g" ${currentjob}
    sbatch -p quick --mem 14GB --job-name ANTs_reg_ROIs_to_meanFunc_${i} ${currentjob}
    rm ${currentjob}

done
