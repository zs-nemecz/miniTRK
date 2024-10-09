#!/bin/sh

for i in `ls ../../Results/01_MRI/fMRI_Preproc/`
do 
	echo ../../Results/01_MRI/fMRI_Preproc/${i} >> epi_bet_pairs.txt
done

tac epi_bet_pairs.txt > bet_epi_pairs.txt

slicesdir -o `cat bet_epi_pairs.txt`