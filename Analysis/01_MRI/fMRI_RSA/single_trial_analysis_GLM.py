#!/usr/bin/env python
# coding: utf-8

import nibabel as nib
import numpy as np
import scipy
import scipy.io as sio
import pandas as pd

import os
import os.path as op
import time
import urllib.request
from tqdm import tqdm # progress bars
from pprint import pprint
import warnings
warnings.filterwarnings('ignore')

from glmsingle.glmsingle import GLM_single


base_folder = op.join('/mnt', 'fmri_data', 'miniTRK', 'Results')
mri_folder = op.join(base_folder, '01_MRI', 'fMRI_Preproc', 'VER3', 'aligned')
design_folder = op.join(base_folder, '02_APS_MRI_Logs', 'single_trials')
subjects = np.loadtxt('test_subjects.txt', dtype=str)
#subjects = ['760384']
print(subjects)


opt = dict()

# set important fields for completeness (but these would be enabled by default)
opt['wantlibrary'] = 1
opt['wantglmdenoise'] = 1
opt['wantfracridge'] = 1


# for the purpose of this example we will keep the relevant outputs in memory
# and also save them to the disk
opt['wantfileoutputs'] = [1,1,1,1]
opt['wantmemoryoutputs'] = [0,0,0,0]
#opt['wanthdf5'] = True

# running python GLMsingle involves creating a GLM_single object
# and then running the procedure using the .fit() routine
glmsingle_obj = GLM_single(opt)

# visualize all the hyperparameters
pprint(glmsingle_obj.params)


# # OBJECT ENCODING

task = 'OBJ'
acq = 'ENC'
stimdur = 3.0
tr = 1.84

# ## Run GLMsingle

for subj in subjects:
    
    # load runs and design files
    data = []
    designs = []
    for r in ['1','2']:
        nii_file = subj + '_' + task + '_' + acq + '_' + r + '_To_ObjEnc1MeanFunc.nii.gz'
        fname = op.join(mri_folder, nii_file)
        img = nib.load(fname)
        data.append(img.get_fdata())

        design_file =  subj + '_' + task + '_SingleTrials_run_' + r + '.csv' 
        fname = op.join(design_folder, design_file)
        design = pd.read_csv(fname).to_numpy()
        designs.append(design)
    
    # create a directory for saving GLMsingle outputs
    outputdir_glmsingle = op.join(base_folder,'01_MRI','fMRI_RSA','GLMsingle', 'original', subj, task + '_' + acq)
    figuredir_glmsingle = op.join(outputdir_glmsingle, 'figures')
    
    print(f'\nsubject: {subj}')
    start_time = time.time()
    print(
        '\tstart time: ',
        f'{time.strftime("%H:%M:%S", time.gmtime(start_time))}'
    )

    if not op.exists(outputdir_glmsingle):

        print(f'running GLMsingle...')

        # run GLMsingle
        results_glmsingle = glmsingle_obj.fit(
           designs,
           data,
           stimdur,
           tr,
           outputdir=outputdir_glmsingle,
           figuredir=figuredir_glmsingle
        )

        time.sleep(10) # wait 10 seconds to make sure saving works

    else:
        print(f'loading existing GLMsingle outputs from directory:\n\t{outputdir_glmsingle}')

        # load existing file outputs if they exist
        results_glmsingle = dict()
        results_glmsingle['typea'] = np.load(op.join(outputdir_glmsingle,'TYPEA_ONOFF.npy'),allow_pickle=True).item()
        results_glmsingle['typeb'] = np.load(op.join(outputdir_glmsingle,'TYPEB_FITHRF.npy'),allow_pickle=True).item()
        results_glmsingle['typec'] = np.load(op.join(outputdir_glmsingle,'TYPEC_FITHRF_GLMDENOISE.npy'),allow_pickle=True).item()
        results_glmsingle['typed'] = np.load(op.join(outputdir_glmsingle,'TYPED_FITHRF_GLMDENOISE_RR.npy'),allow_pickle=True).item()

    elapsed_time = time.time() - start_time

    print(
        '\telapsed time: ',
        f'{time.strftime("%H:%M:%S", time.gmtime(elapsed_time))}'
    )
