#!/bin/sh

#../../Data/01_MRI/bids/sub-279828/anat/sub-279828_T1w_brain
#../../Results/01_MRI/BrainExtraction/sub-279828_T1w_brain

for i in `cat subjects.txt`; do
	echo ../../Data/01_MRI/bids/sub-${i}/anat/sub-${i}_T1w >> t1_bet_pairs.txt
	echo ../../Results/01_MRI/BrainExtraction/sub-${i}_T1w_brain >> t1_bet_pairs.txt
done

slicesdir -o `cat t1_bet_pairs.txt`