#!/bin/bash

PROJECT_DIR="/mnt/fmri_data/miniTRK/"
#done: 205693 279828 317132 338459 446982
for subj in `cat ashs_subjects.txt`; do
	echo ${subj}
	mkdir ${PROJECT_DIR}/Results/01_MRI/ASHS/${subj}
	$ASHS_ROOT/bin/ashs_main.sh -P -I ${subj} -a /mnt/d/Zsuzsa/ashs_atlas_upennpmc_20170810 \
	-g ${PROJECT_DIR}/Results/01_MRI/BrainExtraction/sub-${subj}_T1w_brain.nii.gz -f ${PROJECT_DIR}/Data/01_MRI/bids/sub-${subj}/anat/sub-${subj}_acq-highres_PDw.nii.gz \
	-w ${PROJECT_DIR}/Results/01_MRI/ASHS/${subj}
done
