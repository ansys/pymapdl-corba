**This repository is deprecated**

This respository has been depricated in favor of the new `gRPC <https://grpc.io/>`_ interface developed by Ansys and installed automatically by installing with:

.. code::

   pip install ansys-mapdl-core

This repository will remain here for informational purposes, but will remain archived. You can still use it, but consider it unmaintained.


ansys_corba
===========
This python module provides minimum support for connecting to an ANSYS APDL server using Python.  While it is designed to be used as a support module to support ``pymapdl``, it can be used individually to send text commands to an APDL instance, but with none of the syntax checking or error handling ``pymapdl`` uses.  In short, if you find yourself here, install `pymapdl <http://https://github.com/pyansys/pymapdl>`_ unless you really want a quick and dirty solution to driving ANSYS APDL from Python.

This module relies on documentation provided by ANSYS APDL and uses compiled libraries using both source file from `omniORB <http://omniorb.sourceforge.net/>`_.  See the shell files on the GitHub `repository <http://https://github.com/pyansys/ansys_corba>`_ for Linux build instructions.  Building for Windows was a nightmare.


Installation
------------
Pre-compiled binary files are available for Python 2.7 and 3.5-3.8 for Linux and Windows.  As this repository is no longer maintained in favor of the gRPC interface, these will be the only supported versions of Python.

Installation is simply:

.. code::

    pip install ansys_corba


Usage
-----
Once again, you really should be using ``pymapdl``.  It handles figuring out where the ``mapdl_broadcasts.txt`` file is and when to open a connection with the server.  If you'd rather live on the wild side, here's how you'd open MAPDL, connect to a CORBA server, and send over a few commands:

.. code:: python

    import sys
    import time
    import os
    from ansys_corba import CORBA
    import subprocess
    
    # edit this to match your ansys exe
    ansys_loc = 'C:\\Program Files\\ANSYS Inc\\v170\\ansys\\bin\winx64\\ANSYS170.exe'    

    # ansys apdl logging here:
    logfile = 'mapdl_broadcasts.txt'
    if os.path.isfile(logfile):
        os.remove(logfile)

    # make temporary input file to stop ansys from prompting the user
    with open('tmp.inp', 'w') as f:
        f.write('FINISH')
    
    # start ANSYS
    command = '"%s" -aas -i tmp.inp -o out.txt -b' % ansys_loc
    subprocess.Popen(command, stdout=subprocess.PIPE)
    
    # monitor log file and wait for connection
    print('Starting ANSYS...')
    while True:
        try:
            if os.path.isfile(logfile):
                with open(logfile, 'r') as f:
                    text = f.read()
                    if 'visited:collaborativecosolverunitior' in text:
		        print('ANSYS started')
                        break
                    time.sleep(0.1)
        except KeyboardInterrupt:
            sys.exit()
    
    with open('./aaS_MapdlId.txt') as f:
        key = f.read()
    
    # create server
    orb = CORBA.ORB_init()
    mapdl = orb.string_to_object(key)

    # run simple commands to demonstrate this works
    mapdl.executeCommand('/prep7')
    out = mapdl.executeCommandToString('cylind, 2, , , 2, 0, 90')
    print(out.replace('\\n', '\n'))
    mapdl.executeCommand('FINISH')
    mapdl.terminate()  # could use exit, but it returns an error


There's several things that could break here, for example, your path to MAPDL, or finding the mapdl_broadcasts.txt file.  If this python script isn't running in the same directory as ANSYS, it will hang until you kill the process or exit it with a keyboard interrupt.

Further Documentation
---------------------
Once you've opened a connection to MAPDL, there's really only three commands that you need to use.  This documentation was shamelessly taken from the official MAPDL AAS documentation:

- ``executeCommand``:

  Issues a command to the connected Mechanical APDL session. Output from the command is not returned.

- ``executeCommandToString``

  Issues a command to the connected Mechanical APDL session and returns the output as a string.

- ``terminate``

  Terminates the connected Mechanical APDL as a Server session.

See the MAPDL AAS documentation for more details.


Notes
-----
Installing from source is not possible using PyPi as the shared libraries need to be compiled outside of Python.  I've included ``docker_buildlinux.sh`` and ``docker.sh`` which can be used to build the source code for Linux.  Building for Windows is more complicated and requires following the readme within the omniorb source along with some trial and error.


License and Acknowledgments
---------------------------
This code is licensed under the MIT license.

This module, ``ansys_corba`` makes no commercial claim over MAPDL whatsoever.  This tool extends the functionality of MAPDL by adding a python interface in both file interface as well as interactive scripting without changing the core behavior or license of the original software. The use of the interactive APDL control of ``ansys_corba`` requires a legally licensed local copy of MAPDL.

Also, this module wouldn't be possible without `omniORB`_ as most of the source code is directly take from omniORBpy with only minor modifications to the file structure and the addition of documentation specific to MAPDL.
 
