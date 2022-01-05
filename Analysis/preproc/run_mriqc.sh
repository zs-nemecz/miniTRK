#!/bin/sh

docker run -it --rm -v /mnt/d/Zsuzsa/HCCCL/miniTRK/Data/01_MRI/bids/:/data:ro -v /mnt/d/Zsuzsa/HCCCL/miniTRK/Results/01_MRI/MRIQC:/out \
poldracklab/mriqc:latest /data /out participant \
--participant_label 205693 \
--no-sub