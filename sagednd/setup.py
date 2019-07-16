from setuptools import setup

setup(
   name='sagednd',
   version='0.1.0',
   description='A toy module',
   author='Patrick Clarke',
   author_email='pcc33@drexel.edu',
   packages=['sagednd'],  #same as name
   install_requires=['sage', 'json'], #external packages as dependencies
)
