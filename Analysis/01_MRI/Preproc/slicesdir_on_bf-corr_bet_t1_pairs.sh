#!/bin/sh

#../../Data/01_MRI/bids/sub-279828/anat/sub-279828_T1w_brain
#../../Results/01_MRI/BrainExtraction/sub-279828_T1w_brain

# remove old file with image pairs and create new later
rm corrected_t1_bet_pairs.txt

for i in `cat all_fully_usable_subjects.txt`; do
	echo ../../Results/01_MRI/BrainExtraction/sub-${i}_T1w_corrected >> corrected_t1_bet_pairs.txt
	echo ../../Results/01_MRI/BrainExtraction/sub-${i}_T1w_corrected_brain >> corrected_t1_bet_pairs.txt
done

slicesdir -o `cat corrected_t1_bet_pairs.txt`
