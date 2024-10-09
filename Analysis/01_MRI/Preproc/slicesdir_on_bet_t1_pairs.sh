#!/bin/sh

# remove old file with image pairs and create new later
rm t1_bet_pairs.txt

for i in `cat all_fully_usable_subjects.txt`; do
	echo ../../../Results/01_MRI/BrainExtraction/T_template0POS_sub-${i}_T1wRepaired >> t1_bet_pairs.txt
	echo ../../../Results/01_MRI/BrainExtraction/T_template0POS_sub-${i}_T1wRepaired_brain >> t1_bet_pairs.txt
done

slicesdir -o `cat t1_bet_pairs.txt`
