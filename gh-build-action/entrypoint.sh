#!/bin/bash

cd $GITHUB_WORKSPACE

echo "Running ${@} in $(pwd)"

eval $@

