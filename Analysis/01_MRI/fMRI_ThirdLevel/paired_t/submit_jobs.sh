#!/bin/bash

sbatch --mem 18GB --wrap ". /etc/profile ; module load fsl ; feat LOC_11-9.fsf"

sbatch --mem 18GB --wrap ". /etc/profile ; module load fsl ; feat OBJ_11-9.fsf"
