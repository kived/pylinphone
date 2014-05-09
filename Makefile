.PHONY: all cython build clean

all: build

build: cython

cython: 
	python setup.py build_ext -i

clean:
	python setup.py clean
	find . -name '*.pyc' -exec rm {} \; || :
	( find . -name '*.pyx' | while read pyx; do pyxb=`dirname "$$pyx"`/`basename "$$pyx" .pyx`; rm "$$pyxb".c "$$pyxb".so >/dev/null 2>&1; done ) || :
