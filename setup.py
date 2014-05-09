#!/usr/bin/env python

from itertools import chain
from setuptools import setup, find_packages, Extension as se_Extension
from Cython.Distutils import build_ext, Extension as cy_Extension
import fnmatch, os, sys

packages = [pkg for pkg in find_packages('.')]

def Extension(*args, **kwargs):
	try:
		return cy_Extension(*args, **kwargs)
	except:
		return se_Extension(*args, **kwargs)

inc_dirs = ['.']
lib_dirs = []
libs = ['linphone']

try:
	sys.argv.remove('debug')
except ValueError:
	global_compile_args = ['-O3']
	debug_build = False
else:
	global_compile_args = ['-O0', '-g', '-ggdb', '-DDEBUG']
	debug_build = True

def make_cy_ext(filename, inc_dirs=inc_dirs, lib_dirs=lib_dirs, libs=libs, global_compile_args=global_compile_args, debug_build=debug_build):
	modname = filename.replace('.pyx', '').replace('/', '.')
	return Extension(name=modname, sources=[filename], 
					 include_dirs=inc_dirs, library_dirs=lib_dirs, libraries=libs,
					 extra_compile_args=global_compile_args + ['-fPIC'],
					 extra_link_args=global_compile_args + ['-fPIC'],
					 pyrex_gdb=debug_build,
					 cython_directives={'embedsignature': True})

cython_ext = []
for root, dirname, filenames in os.walk('pylinphone'):
	for filename in fnmatch.filter(filenames, '*.pyx'):
		cython_ext.append(make_cy_ext(os.path.join(root, filename)))

version = file('VERSION').read().strip()

setup(name='pylinphone',
	  version=version,
	  description='Python bindings for liblinphone',
	  author='Ryan Pessa',
	  author_email='ryan@essential-elements.net',
	  url='https://github.com/kived/pylinphone',
	  packages=packages,
	  
	  cmdclass={'build_ext': build_ext},
	  ext_modules=cython_ext,
	  
	  )

