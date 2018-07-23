import sys
import ctypes
import os
import glob

path = os.path.dirname(os.path.realpath(__file__))

# let the user know that this must be installed as a wheel
if not glob.glob('_omni'):
    raise Exception('ansys_corba is missing binary files\n\n' +\
                    'Please install using PyPi with:\n' +\
                    '\tpip install ansys_corba\n\n' +\
                    "Check to make sure your OS is supported:" +\
                    '\nLinux 64-bit:\n\tPython2.7\n\tPython3.4\n\tPython3.5\n\tPython3.6' +\
                    '\nWindows 64-bit:\n\tPython2.7\n\tPython3.5\n\tPython3.6\n\n' +\
                    'If your OS os supported and you still encounter this error\n' +\
                    'open an issue on GitHub at:\n' +\
                    'https://github.com/akaszynski/ansys_corba/issues')


# add this directory to the system path
sys.path.insert(0, path)

# add shared libaries to the path
libs = ['libomnithread.so.4', 'libomniORB4.so.2',]
for lib in libs:
    libfile = os.path.join(path, lib)
    if os.path.isfile(libfile):
        ctypes.cdll.LoadLibrary(libfile)

from omniORB import CORBA
import AAS_CORBA
