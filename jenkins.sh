#!/bin/bash

set -x
set -eu

export BUNDLER_ARGS="--path ${HOME}/bundles/${JOB_NAME}"
make test
