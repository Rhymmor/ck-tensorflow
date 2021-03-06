#
# Preprocessing Caffe templates
#
# Developer: Grigori Fursin, cTuning foundation, 2016
#

import json
import os
import re

def ck_preprocess(i):

    deps=i['deps']

    nenv={} # new environment to be added to the run script

    hosd=i['host_os_dict']
    tosd=i['target_os_dict']
    remote=tosd.get('remote','')

    # Find template
    x=deps['tensorflow-aux']
    y=deps['tensorflow-model-imagenet']

    pb_path_full=x['dict']['env']['CK_ENV_DATASET_TENSORFLOW_STRIPPED_AUX'] + '/tensorflow_inception_stripped.pb'
    nenv['CK_ENV_DATASET_TENSORFLOW_AUX_PB']=pb_path_full

    txt_path_full=x['dict']['env']['CK_ENV_DATASET_TENSORFLOW_STRIPPED_AUX'] + '/imagenet_comp_graph_label_strings.txt'
    nenv['CK_ENV_DATASET_TENSORFLOW_AUX_TXT']=txt_path_full

    img_path_full=y['dict']['env']['CK_ENV_MODEL_TENSORFLOW'] + '/cropped_panda.jpg'
    nenv['CK_ENV_DATASET_TENSORFLOW_AUX_IMG']=img_path_full

    if remote=='yes':
       # For Android we need only filename without full path
       pb_path=os.path.basename(pb_path_full)
       txt_path=os.path.basename(txt_path_full)
       img_path=os.path.basename(img_path_full)
    else:
       pb_path=pb_path_full
       txt_path=txt_path_full
       img_path=img_path_full

    nenv['CK_DATASET_TENSORFLOW_AUX_PB']=pb_path
    nenv['CK_DATASET_TENSORFLOW_AUX_TXT']=txt_path
    nenv['CK_DATASET_TENSORFLOW_AUX_IMG']=img_path

    return {'return':0, 'new_env':nenv}

# Do not add anything here!
