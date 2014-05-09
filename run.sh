#!/bin/bash -e

if [ -z "$1" ]; then
	runcmd=tpython
else
	runcmd="$1"
	shift
fi

LD_LIBRARY_PATH="$LD_LIBRARY_PATH" "$runcmd" "$@"
