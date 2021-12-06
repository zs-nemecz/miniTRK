#!/bin/sh

docker run -it --rm -v /mnt/d/Zsuzsa/HCCCL/miniTRK/Data/01_MRI/bids/:/data:ro -v /../../Results/01_MRI/MRIQC:/out poldracklab/mriqc:latest /data /out participant --participant_label 205693 279828 317132 338459 446982 457424 463594 473321 526477 546563 553081 618650 672857 700822 766406 876066 936212 968873 982595