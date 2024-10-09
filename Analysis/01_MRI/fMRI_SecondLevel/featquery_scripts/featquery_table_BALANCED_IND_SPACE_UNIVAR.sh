#!/bin/bash
SECOND_LEVEL_PATH='/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_SecondLevel/UNIVAR/IND_SPACE/BALANCED'

# adding headers to our table. BEWARE: this will delete your old table with the same filename
echo "ID;Task;CopeNr;Mask;Hemi;Area;FeatqueryNr;Min;Mean%;Median%;Max;Stddev" > BALANCED_IND_SPACE_UNIVAR_featquery_table.csv
echo "ID;Task;CopeNr;Mask;Hemi;Area;FeatqueryNr;Nvox" > BALANCED_IND_SPACE_UNIVAR_voxelcheck_table.csv

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for subject in `cat $varname`; do
	echo ${subject}
	for task in OBJ LOC; do
		echo ${task}
		for cope in 1 2 3 4 5 6 7 8 9 10 11 12; do
			echo ${cope}
			for area in CA1 CA3DG SUB ERC PRC PHC; do
				for hemi in left right; do
					echo ${hemi} ${area}
					# col 1 is featquery number
					# col 3 number of voxels
					# col 4 is min % signal change
					# col 6: mean
					# col 7: median
					# col 9: maximum
					# col 10: standard deviation
					FTQR_NUM=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $1}'`
					NVOX_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $3}'`
					MIN_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $4}'`
					MEAN_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $6}'`
					MEDIAN_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $7}'`
					MAX_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $9}'`
					STDDEV_VAL=`cat ${SECOND_LEVEL_PATH}/${subject}/${subject}_ENC_${task}.gfeat/cope${cope}.feat/corrected_${hemi}_${area}/report.txt | grep stats/pe1 | awk '{print $10}'`
					echo ${MEAN_VAL}
					echo ${MEDIAN_VAL}
					echo "${subject};${task};${cope};${hemi}_${area};${hemi};${area};${FTQR_NUM};${MIN_VAL};${MEAN_VAL};${MEDIAN_VAL};${MAX_VAL};${STDDEV_VAL}" >> BALANCED_IND_SPACE_UNIVAR_featquery_table.csv
				done # hemi
				echo ${NVOX_VAL}
				echo "${subject};${task};${cope};${hemi}_${area};${hemi};${area};${FTQR_NUM};${NVOX_VAL}" >> BALANCED_IND_SPACE_UNIVAR_voxelcheck_table.csv
			done # area
		done # cope number
	done # task
done # subject
