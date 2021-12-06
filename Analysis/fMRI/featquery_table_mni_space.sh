#!/bin/bash
SECOND_LEVEL_PATH='/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel/'
# add subjects 546563 968873 317132
for subject in `cat subjects.txt`; do
	echo ${subject}
	for task in OBJ LOC; do
		echo ${task}
		for cope in 1 2 3 4 5 6 8; do
			echo ${cope}
			for mask in `ls /mnt/d/Zsuzsa/HCCCL/miniTRK/Analysis/fMRI/masks/bin-* | xargs -n 1 basename`; do
				echo ${mask}
				MEAN_VAL=`cat /mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel/${subject}/${task}_ENC.gfeat/cope${cope}.feat/featquery_${mask%.*.*}/report.txt | grep stats/cope1 | awk '{print $1 "; " $6}'` # "# featdir" value (column 1) and the mean (column 6). median is column 7
				echo "${subject};${task};${cope};${mask%.*.*};${MEAN_VAL}" >> featquery_tabel.csv
			done
		done
	done
done