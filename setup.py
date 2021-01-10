"""Installation file for ansys-mapdl-corba"""
from setuptools import setup

setup(name='ansys-mapdl-corba',
      packages=['ansys.mapdl.corba'],
      version='0.2.0',
      description='ANSYS MAPDL interface using partial files from omniORB and omniORBpy',
      long_description=open('README.rst').read(),
      license='MIT',
      classifiers=[
          'Programming Language :: Python :: 3.5',
          'Programming Language :: Python :: 3.6',
          'Programming Language :: Python :: 3.7',
          'Programming Language :: Python :: 3.8',
      ],

      url='https://github.com/pyansys/pymapdl-corba',
      keywords='ANSYS APDL MAPDL CORBA omniorb omniORBpy',
      include_package_data=True
)
