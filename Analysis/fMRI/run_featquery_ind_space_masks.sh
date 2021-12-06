#!/bin/bash
SECOND_LEVEL_PATH='/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel'
ANTS_PATH='/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/ANTS_REG'
# run LOC for subj 317132
for task in OBJ LOC; do
	for subject in `cat subjects.txt`; do
		for mask in CA1 CA3DG SUB ERC PRC PHC; do
			for hemi in left right
			do
				echo ${task} ${subject} ${mask} ${hemi}
				featquery 7 \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope1.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope2.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope3.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope4.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope5.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope6.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_ENC.gfeat/cope8.feat \
				1  stats/pe1 \
				${hemi}_${mask} \
				-p -s ${ANTS_PATH}/${subject}/${subject}_${hemi}_${mask}2midFunc.nii.gz
			done
		done
	done
done


