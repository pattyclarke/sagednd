# -*- coding: utf-8 -*-

import os
import sys
from setuptools import setup
from codecs import open # To open the README file with proper encoding
from setuptools.command.test import test as TestCommand # for tests

# Get information from separate files (README, VERSION)
def readfile(filename):
    with open(filename,  encoding='utf-8') as f:
        return f.read()
    
# For the tests
class SageTest(TestCommand):
    def run_tests(self):
        errno = os.system("sage -t --force-lib sagednd")
        if errno != 0:
            sys.exit(1)

setup(
    name='sagednd',
    version=readfile("VERSION").strip(), # the VERSION file is shared with the documentation
    description='A toy module computing some DnD statistics',
    long_description = readfile("README.rst"), # get the long description from the README
    author='Patrick Clarke',
    author_email='pattyclarke@gmail.com',
    classifiers=[
      # How mature is this project? Common values are
      #   3 - Alpha
      #   4 - Beta
      #   5 - Production/Stable
      'Development Status :: 4 - Beta',
      'Intended Audience :: Education',
      'Topic :: Software Development :: Build Tools',
      'License :: OSI Approved :: GNU General Public License v2 or later (GPLv2+)',
      'Programming Language :: Python :: 3.7.3',
    ], # classifiers list: https://pypi.python.org/pypi?%3Aaction=list_classifiers
    license='GPLv2+', # This should be consistent with the LICENCE file
    packages=['sagednd'],  #same as name
    cmdclass = {'test': SageTest}, # adding a special setup command for tests
    setup_requires =['sagednd']
    install_requires=['sage', 'json', 'sphynx'], #external packages as dependencies
)
