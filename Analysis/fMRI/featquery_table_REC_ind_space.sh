#!/bin/bash
SECOND_LEVEL_PATH='/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel'
# add subjects 546563 968873 317132
echo "ID;Task;CopeNr;Mask;Hemi;Area;FeatqueryNr;Mean%" >> REC_featquery_table.csv
for subject in `cat subjects.txt`; do
	echo ${subject}
	for task in OBJ LOC; do
		echo ${task}
		for cope in 1 2 3 4 5 6 7 8; do
			echo ${cope}
			for mask in CA1 CA3DG SUB ERC PRC PHC; do
				for hemi in left right; do
					echo ${mask}
					MEAN_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope${cope}.feat/${hemi}_${mask}/report.txt | grep stats/pe1 | awk '{print $1 "; " $6}'` # "# featdir" value (column 1) and the mean (column 6). median is column 7
					echo ${MEAN_VAL}
					echo "${subject};${task};${cope};${hemi}_${mask};${hemi};${mask};${MEAN_VAL}" >> REC_featquery_table.csv
				done
			done
		done
	done
done