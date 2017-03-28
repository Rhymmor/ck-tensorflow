#
# Collective Knowledge (individual environment - setup)
#
# See CK LICENSE.txt for licensing details
# See CK COPYRIGHT.txt for copyright details
#
# Developer: Grigori Fursin
#

import os

##############################################################################
# setup environment setup

def setup(i):
    """
    Input:  {
              cfg              - meta of this soft entry
              self_cfg         - meta of module soft
              ck_kernel        - import CK kernel module (to reuse functions)

              host_os_uoa      - host OS UOA
              host_os_uid      - host OS UID
              host_os_dict     - host OS meta

              target_os_uoa    - target OS UOA
              target_os_uid    - target OS UID
              target_os_dict   - target OS meta

              target_device_id - target device ID (if via ADB)

              tags             - list of tags used to search this entry

              env              - updated environment vars from meta
              customize        - updated customize vars from meta

              deps             - resolved dependencies for this soft

              interactive      - if 'yes', can ask questions, otherwise quiet
            }

    Output: {
              return       - return code =  0, if successful
                                         >  0, if error
              (error)      - error text if return > 0

              bat          - prepared string for bat file
            }

    """

    import os

    # Get variables
    ck=i['ck_kernel']
    s=''

    iv=i.get('interactive','')

    cus=i.get('customize',{})
    fp=cus.get('full_path','')

    hosd=i['host_os_dict']
    tosd=i['target_os_dict']

    env=i['env']
    ep=cus['env_prefix']

    p1=os.path.dirname(fp)
    pl=os.path.dirname(p1)
    pi=os.path.dirname(pl)

    env[ep]=pi

    makefile_env = ep + "_MAKEFILE_DIR"
    makefile_path = p1 + '/contrib/makefile'
    env[makefile_env] = makefile_path

    makefile_downl_env = makefile_env + '_DOWNLOADS'
    makefile_downl_path = makefile_path + '/downloads'
    env[makefile_downl_env] = makefile_downl_path
    env[makefile_downl_env + '_EIGEN'] = makefile_downl_path + '/eigen'
    env[makefile_downl_env + '_GEMMLOWP'] = makefile_downl_path + '/gemmlowp'

    makefile_gen_env = makefile_env + '_GEN'
    makefile_gen_path = makefile_path + '/gen'
    env[makefile_gen_env] = makefile_gen_path
    env[makefile_gen_env + '_PROTO'] = makefile_gen_path + '/proto'
    env[makefile_gen_env + '_PROTOTEXT'] = makefile_gen_path + '/proto_text'
    env[makefile_gen_env + '_PROTOTEXT'] = makefile_gen_path + '/proto_text'
    env[makefile_gen_env + '_PROTOBUF_HOST_INCUDE'] = makefile_gen_path + '/protobuf-host/include'
    env[makefile_gen_env + '_PROTOBUF_HOST_INCUDE'] = makefile_gen_path + '/protobuf-host/include'
    env[makefile_gen_env + '_TOOLS'] = makefile_gen_path + '/obj/tensorflow/tools/benchmark'
    env[makefile_gen_env + '_LIB'] = makefile_gen_path + '/lib'

    cus['path_lib']=p1 + '/contrib/makefile/gen/protobuf/lib'

    r = ck.access({'action': 'lib_path_export_script', 
                   'module_uoa': 'os', 
                   'host_os_dict': hosd, 
                   'lib_path': cus.get('path_lib', '')})
    if r['return']>0: return r
    s += r['script']


    return {'return':0, 'bat':s}
