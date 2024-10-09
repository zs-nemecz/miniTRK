#!/bin/sh

PF='../../Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2023-06-21'

for task in LOC OBJ; do
	for acq in ENC REC; do 
		for ses in 1 2; do
			mkdir temp
			rm ${task}_${acq}_${ses}_epi_highres_pairs.txt
			rm ${task}_${acq}_${ses}_slicesdir -r
			mkdir ${task}_${acq}_${ses}_slicesdir
			for i in `cat all_fully_usable_subjects.txt`; do
				cp ${PF}/${i}/${i}_task-${task}_acq-${acq}_run-${ses}.feat/reg/example_func2highres.nii.gz temp
				cp ${PF}/${i}/${i}_task-${task}_acq-${acq}_run-${ses}.feat/reg/highres.nii.gz temp
				mv temp/example_func2highres.nii.gz temp/${i}_${task}_${acq}_${ses}.nii.gz
				mv temp/highres.nii.gz temp/${i}_highres.nii.gz
				
				echo temp/${i}_${task}_${acq}_${ses}.nii.gz >> ${task}_${acq}_${ses}_epi_highres_pairs.txt
				echo temp/${i}_highres.nii.gz >> ${task}_${acq}_${ses}_epi_highres_pairs.txt
				# switch background and overlay
				echo temp/${i}_highres.nii.gz >> ${task}_${acq}_${ses}_epi_highres_pairs.txt
				echo temp/${i}_${task}_${acq}_${ses}.nii.gz >> ${task}_${acq}_${ses}_epi_highres_pairs.txt
			done
			slicesdir -o `cat ${task}_${acq}_${ses}_epi_highres_pairs.txt`
			mv slicesdir ${task}_${acq}_${ses}_slicesdir
			rm temp -r
		done
	done
done

