#!/bin/bash


docker run -it --rm -v /mnt/fmri_data/miniTRK/Data/01_MRI/bids/:/data:ro -v /mnt/fmri_data/miniTRK/Results/01_MRI/MRIQC:/out \
nipreps/mriqc:latest /data /out group \
--no-sub
	
