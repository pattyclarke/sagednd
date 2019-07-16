from setuptools import setup

setup(
   name='sagednd',
   version='0.1.0',
   description='A toy/template module',
   author='Patrick Clarke',
   author_email='pattyclarke@gmail.com',
   packages=['sagednd'],  #same as name
   install_requires=['sage'], #external packages as dependencies
)
