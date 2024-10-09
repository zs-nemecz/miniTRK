#!/bin/bash

OUTPATH="/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/VER3/aligned"

echo "Type subject list file:"

read varname

for subj in `cat $varname`; do
	
	# I use the VER1 preprocessed mean_func, because both VER1 and VER2 are 0 mm smoothing
	REFVOL="/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/fmap_0mm-smoothing_T1_2023-06-21/${subj}/${subj}_task-OBJ_acq-ENC_run-1.feat/mean_func_corrected_brain.nii.gz"
	
	for task in OBJ LOC; do 
		for r in 1 2; do
			
			RUN_NAME="${task}_ENC_${r}"
			INPUTMATRIX="/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_FirstLevel/VER1_fmap_0mm-smoothing_ind-space/${subj}/${RUN_NAME}.feat/reg/example_func2standard.mat"
			INPUTRUN="/mnt/fmri_data/miniTRK/Results/01_MRI/fMRI_Preproc/VER3/${subj}/${subj}_task-${task}_acq-ENC_run-${r}.feat/filtered_func_data.nii.gz"
			
			echo "input run: ${INPUTRUN}"
			echo "reference volume: ${REFVOL}"
			echo "matrix used: ${INPUTMATRIX}"
			echo "#!/bin/bash" >  ${OUTPATH}/scripts/${subj}_${RUN_NAME}.sh
			echo "flirt -in ${INPUTRUN} -ref ${REFVOL} -applyxfm -init ${INPUTMATRIX} -out ${OUTPATH}/${subj}_${RUN_NAME}_To_ObjEnc1MeanFunc" >> ${OUTPATH}/scripts/${subj}_${RUN_NAME}.sh	
			
		done
	done
	
done
			
			
