#!/bin/bash
DATA_PATH=../../Data/01_MRI

for id in `cat dicom_files.txt`; do
	echo ID: ${id}
	# convert dicoms directly to BIDS format according to the config file
	dcm2bids -d ${DATA_PATH}/dicom/${id}/ -p ${id} -c mTRK_dcm2bids_config.json -o ${DATA_PATH}/bids/
	# don't forget to pydeface T1 and wbPD!!
	# removed from config file: "defaceTpl": "pydeface --outfile {dstFile} {srcFile}"
	pydeface ${DATA_PATH}/bids/sub-${id}/anat/sub-${id}_T1w.nii.gz --outfile ${DATA_PATH}/bids/sub-${id}/anat/sub-${id}_T1w.nii.gz --force
	pydeface ${DATA_PATH}/bids/sub-${id}/anat/sub-${id}_acq-lowres_PDw.nii.gz --outfile ${DATA_PATH}/bids/sub-${id}/anat/sub-${id}_acq-lowres_PDw.nii.gz --force
done
