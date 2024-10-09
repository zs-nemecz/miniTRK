#!/bin/sh

module load fsl

OUT_PATH="~/Projects/miniTRK/Results/01_MRI/fMRI_Preproc"

echo "Type subject list file:"

read varname

echo "Selected file $varname"


for participant in `cat ${varname}`; do

	for acq in ENC REC; do
		for task in OBJ LOC; do 
			for run in 1 2; do 

				currentdesign="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_Preproc/UNIVAR/design_files/Preprocess_${participant}_${task}_${acq}_${run}.fsf"
				magnitude=`ls /home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_Preproc/fieldmaps/sub-${participant}_acq-${task}_run-?_magnitude_mean_brain.nii.gz | sed -e 's/\.nii.gz$//'`
				fmap=`ls /home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/fMRI_Preproc/fieldmaps/sub-${participant}_acq-${task}_run-?_fmap.nii.gz | sed -e 's/\.nii.gz$//'`
				echo ${currentdesign}
				
				# copy template design file into participant's design file
				cp fMRI_Preprocess_UNIVAR_2023-12-15.fsf $currentdesign

				sed -i "s|%PARTICIPANT%|${participant}|g" $currentdesign
				sed -i "s|%TASK%|${task}|g" $currentdesign
				sed -i "s|%ACQ%|${acq}|g" $currentdesign
				sed -i "s|%RUN%|${run}|g" $currentdesign
				sed -i "s|%FMAP%|${fmap}|g" $currentdesign
				sed -i "s|%MAGNITUDE%|${magnitude}|g" $currentdesign	

				if [[ $acq == ENC ]]; then
					echo ENC
					sed -i "s|%NVOLUMES%|250|g" $currentdesign
				elif [[ $acq == REC ]]; then
					echo REC
					sed -i "s|%NVOLUMES%|148|g" $currentdesign
				fi

				#mem requirement modified to 10GB because may exceeded 8GB and 1 job failed 
				sbatch --mem 10GB --wrap ". /etc/profile ; module load fsl ; feat $currentdesign"
				# test:
				# srun -p test -c 2 --mem 8GB --pty bash -c 'module load fsl ; feat $currentdesign'
			done
		done
	done
	echo "submitted participant ${participant}"
done
