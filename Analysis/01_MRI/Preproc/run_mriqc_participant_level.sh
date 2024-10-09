#!/bin/bash

IDs=`cat test_subjects_row.txt`

for i in $IDs;
do 
	echo ${i}
	docker run -it --rm -v /mnt/fmri_data/miniTRK/Data/01_MRI/bids/:/data:ro -v /mnt/fmri_data/miniTRK/Results/01_MRI/MRIQC:/out \
	poldracklab/mriqc:0.16.1 /data /out participant \
	--participant_label ${i} \
	--no-sub
	echo ${i} END
	echo 
done
	
