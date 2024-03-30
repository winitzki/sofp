#!/bin/bash
curl -fLo coursier https://git.io/coursier-cli-"$(uname | tr LD ld)"
#curl -L -o coursier https://git.io/coursier
chmod +x coursier
