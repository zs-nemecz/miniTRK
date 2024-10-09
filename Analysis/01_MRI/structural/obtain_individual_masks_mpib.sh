#!/bin/sh

# set directory for feat results
IOPATH="../../../Results/01_MRI/ASHS/MPIB_Atlas/MPIB_wholebrain_T1/original"

# define lower and upper threshold values
# first value is lower threshold, second value is upper threshold
declare -a CA1_t=(10.5 12.5)
declare -a CA3DG_t=(20.5 22.2)
declare -a SUB_t=(30.5 32.5)
declare -a ERC_t=(40.5 42.5)


# arrays for each masks lower and upper threshold value. we will loop through these later
# when calling fslmaths
declare -A thr=( ["CA1"]=${CA1_t[0]} ["CA3DG"]=${CA3DG_t[0]} ["SUB"]=${SUB_t[0]} \
 ["ERC"]=${ERC_t[0]})

declare -A uthr=( ["CA1"]=${CA1_t[1]} ["CA3DG"]=${CA3DG_t[1]} ["SUB"]=${SUB_t[1]} \
 ["ERC"]=${ERC_t[1]})


for subj in `cat all_fully_usable_subjects.txt`
do
	echo ${subj}

	for mask in "${!uthr[@]}"
	do
		echo "$mask - lower: ${thr[$mask]} upper: ${uthr[$mask]}"

    ## treshold image according to defined values and binarize
		## left
		LFILE=${IOPATH}/${subj}_left_lfseg_corr_usegray.nii.gz
    	if test -f "$LFILE"; then
    		echo "left file exists"
			fslmaths ${IOPATH}/${subj}_left_lfseg_corr_usegray.nii.gz \
			-thr ${thr[$mask]} -uthr ${uthr[$mask]} -bin ${IOPATH}/original_masks/${subj}_left_${mask}_mask
		fi

		RFILE=${IOPATH}/${subj}_right_lfseg_corr_usegray.nii.gz
    	if test -f "$RFILE"; then
    		echo "right file exists"
			## right
			fslmaths ${IOPATH}/${subj}_right_lfseg_corr_usegray.nii.gz \
			-thr ${thr[$mask]} -uthr ${uthr[$mask]} -bin ${IOPATH}/original_masks/${subj}_right_${mask}_mask
		fi

	done
done
