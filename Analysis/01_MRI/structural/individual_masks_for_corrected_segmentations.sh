#!/bin/bash
module load fsl

# set directory for feat results
IOPATH="../../../Results/01_MRI/ASHS/UPENN_Atlas/ASHS_UPENN_wholebrain_T1"

# define lower and upper threshold values
# first value is lower threshold, second value is upper threshold
declare -a CA1_t=(0.5 1.5)
declare -a CA2_t=(1.8 2.2)
declare -a DG_t=(2.5 3.2)
declare -a CA3_t=(3.5 4.5)
declare -a SUB_t=(7.5 8.5)
declare -a ERC_t=(9.5 10.5)
declare -a BA35_t=(10.8 11.3)
declare -a BA36_t=(11.5 12.3)
declare -a PHC_t=(12.5 13.5)

# some combined masks
declare -a PRC_t=(10.5 12.5)
declare -a CA3DG_t=(2.5 4.5)

# arrays for each masks lower and upper threshold value. we will loop through these later
# when calling fslmaths
declare -A thr=( ["CA1"]=${CA1_t[0]} ["CA3DG"]=${CA3DG_t[0]} ["SUB"]=${SUB_t[0]} \
 ["ERC"]=${ERC_t[0]} ["PRC"]=${PRC_t[0]} ["CA2"]=${CA2_t[0]} ["DG"]=${DG_t[0]} \
 ["CA3"]=${CA3_t[0]} ["BA35"]=${BA35_t[0]} ["BA36"]=${BA36_t[0]} ["PHC"]=${PHC_t[0]})

declare -A uthr=( ["CA1"]=${CA1_t[1]} ["CA3DG"]=${CA3DG_t[1]} ["SUB"]=${SUB_t[1]} \
 ["ERC"]=${ERC_t[1]} ["PRC"]=${PRC_t[1]} ["CA2"]=${CA2_t[1]} ["DG"]=${DG_t[1]} \
 ["CA3"]=${CA3_t[1]} ["BA35"]=${BA35_t[1]} ["BA36"]=${BA36_t[1]} ["PHC"]=${PHC_t[1]})


for subj in `cat missed_subjects.txt`
do
	echo ${subj}


	for mask in "${!uthr[@]}"
	do
		echo "$mask - lower: ${thr[$mask]} upper: ${uthr[$mask]}"

		## treshold image according to defined values and binarize
		## left
		LFILE=${IOPATH}/corrected/${subj}_left_lfseg_corr_usegray.nii.gz
    	if test -f "$LFILE"; then
    		echo "corrected left file exists"
			fslmaths ${IOPATH}/corrected/${subj}_left_lfseg_corr_usegray.nii.gz \
			-thr ${thr[$mask]} -uthr ${uthr[$mask]} -bin ${IOPATH}/corrected/masks/${subj}_left_${mask}_mask
		fi

		RFILE=${IOPATH}/corrected/${subj}_right_lfseg_corr_usegray.nii.gz
    	if test -f "$RFILE"; then
    		echo "corrected right file exists"
			## right
			fslmaths ${IOPATH}/corrected/${subj}_right_lfseg_corr_usegray.nii.gz \
			-thr ${thr[$mask]} -uthr ${uthr[$mask]} -bin ${IOPATH}/corrected/masks/${subj}_right_${mask}_mask
		fi

	done
done
