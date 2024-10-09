#!/bin/bash

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for i in `cat $varname`; do

    echo ${i}
    # create empty design file for the current phase and run
    currentjob="hPD_to_TemplateSpaceT1_${i}.job"
    echo ${currentjob}
    # copy the full template script into the participant specific script
    cp hPD_to_TemplateSpaceT1.job ${currentjob}
    # edit the design file
    sed -i "s|%PARTICIPANT%|${i}|g" ${currentjob}
    sbatch -p quick --mem 6GB ${currentjob}
    rm ${currentjob}

done
