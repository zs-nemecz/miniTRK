#!/bin/sh

#../../Data/01_MRI/bids/sub-279828/anat/sub-279828_T1w_brain
#../../Results/01_MRI/BrainExtraction/sub-279828_T1w_brain

for i in `cat subjects.txt`; do
	echo ../../Data/01_MRI/bids/sub-${i}/anat/sub-${i}_acq-lowres_PDw >> pd_bet_pairs.txt
	echo ../../Results/01_MRI/BrainExtraction/sub-${i}_acq-lowres_PDw_brain >> pd_bet_pairs.txt
done

slicesdir -o `cat pd_bet_pairs.txt`