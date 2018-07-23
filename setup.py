"""
Installation file for omniORBpy
"""
import os
import sys
from io import open as io_open
import pip

from setuptools import setup, Extension

setup(
    name='ansys_corba',
    packages=['ansys_corba'],

    # Version
    version='0.1.0',
    description='ANSYS MAPDL interface using partial files from omniORB and omniORBpy',
    long_description=open('README.rst').read(),

    # Author details
    author='Alex Kaszynski',
    author_email='akascap@gmail.com',

    license='MIT',
    classifiers=[
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
    ],

    url='https://github.com/akaszynski/ansys_corba',
    keywords='ANSYS APDL MAPDL CORBA omniorb omniORBpy',
    include_package_data=True

)
