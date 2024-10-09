#!/bin/bash

IN="/home/mpib/nemecz/Projects/miniTRK/Data/01_MRI/bids"
OUT="/home/mpib/nemecz/Projects/miniTRK/Results/01_MRI/FreeSurfer"
OPTS="-openmp 6 -threads 6 -all"

mkdir -p $OUT

for sub in `cat missed_subjects.txt` ; do
    echo '#!/bin/bash'                                                           > jobfile
    echo "#SBATCH --output $HOME/logs/slurm-%j.out"                             >> jobfile
    echo "#SBATCH --cpus-per-task 6"                                            >> jobfile
    echo "#SBATCH --mem 4GB"                                                    >> jobfile
    echo "module load freesurfer/7.4.1"                                         >> jobfile
    echo "recon-all $OPTS -i $IN/sub-$sub/anat/sub-??????_T1w.nii.gz -subjid ${sub} -sd $OUT" >> jobfile

    sbatch jobfile
done

