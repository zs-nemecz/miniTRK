#!/bin/bash
SECOND_LEVEL_PATH='/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel/'
# run LOC for subj 317132
for task in OBJ LOC; do
	for subject in `cat subjects.txt`; do
		for mask in `ls /mnt/d/Zsuzsa/HCCCL/miniTRK/Analysis/fMRI/masks/bin-* | xargs -n 1 basename`; do
			echo ${task} ${subject} ${mask%.*.*}
			featquery 7 \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope1.feat \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope2.feat \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope3.feat \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope4.feat \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope5.feat \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope6.feat \
			${SECOND_LEVEL_PATH}${subject}/${task}_ENC.gfeat/cope8.feat \
			6  stats/pe1 stats/cope1 stats/varcope1 stats/tstat1 stats/zstat1 thresh_zstat1 \
			featquery_${mask%.*.*} -p -s /mnt/d/Zsuzsa/HCCCL/miniTRK/Analysis/fMRI/masks/${mask}
		done
	done
done


