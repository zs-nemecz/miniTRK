#!/bin/bash
SECOND_LEVEL_PATH="/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel"
ANTS_PATH="/mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/ANTS_REG"

# to delete all previous featquery folders, run:
# for i in `ls -d /mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/fMRI_SecondLevel/*`; do rm -r ${i}/*.gfeat/cope*/left_*; rm -r ${i}/*.gfeat/cope*/right_*; done

echo "Type subject list file:"

read varname

echo "Selected file $varname"

for task in OBJ LOC; do
	for subject in `cat ${varname}`; do
		for mask in CA1 CA3DG SUB ERC PRC PHC; do
			for hemi in left right
			do
				echo ${task} ${subject} ${mask} ${hemi}
				featquery 8 \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope1.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope2.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope3.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope4.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope5.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope6.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope7.feat \
				${SECOND_LEVEL_PATH}/${subject}/${task}_REC.gfeat/cope8.feat \
				1  stats/pe1 \
				${hemi}_${mask} \
				-p -s ${ANTS_PATH}/${subject}/${subject}_${hemi}_${mask}2midFunc.nii.gz
			done
		done
	done
done



