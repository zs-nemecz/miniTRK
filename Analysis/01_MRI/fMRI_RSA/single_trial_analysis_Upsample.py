#!/usr/bin/env python
# coding: utf-8

import nibabel as nib
import numpy as np
import scipy
import scipy.io as sio
import pandas as pd

# for upsampling
from slicetime.main import run_slicetime
from slicetime.make_image_stack import make_image_stack

import os
import os.path as op
import time
import urllib.request
from tqdm import tqdm # progress bars
from pprint import pprint
import warnings
warnings.filterwarnings('ignore')


base_folder = op.join('D:\\', 'Zsuzsa', 'HCCCL', 'miniTRK', 'Results')
mri_folder = op.join(base_folder, '01_MRI', 'fMRI_Preproc', 'VER3', 'aligned')
design_folder = op.join(base_folder, '02_APS_MRI_Logs', 'single_trials')
subjects = np.loadtxt('test_subjects.txt', dtype=str)
print(subjects)


# # OBJECT ENCODING

task = 'OBJ'
acq = 'ENC'
stimdur = 3.0
tr = 1


# ## Upsample Data


tr_old = 1.84
tr_new = tr
time_dim = 3
offset = 0
n_slices = 80

for subj in subjects:
    
    for r in ['1','2']:
        start_time = time.time()
        
        original_fname = subj + '_' + task + '_' + acq + '_' + r + '_To_ObjEnc1MeanFunc.nii.gz'
        upsampled_fname = subj + '_' + task + '_' + acq + '_' + r + '_To_ObjEnc1MeanFunc_Upsampled.nii.gz'
        in_file = op.join(mri_folder, original_fname)
        out_file = op.join(mri_folder, upsampled_fname)

        # sliceorder needs to be 1-based (see fakeout below)
        slicetimes = np.flip(np.arange(0, tr_old, tr_old/n_slices))
        
        run_slicetime(
        inpath=in_file,
        outpath=out_file,
        slicetimes=slicetimes,
        tr_old=tr_old,
        tr_new=tr_new,
        )
        
        elapsed_time = time.time() - start_time

        print(
            '\telapsed time: ',
            f'{time.strftime("%H:%M:%S", time.gmtime(elapsed_time))}'
        )
