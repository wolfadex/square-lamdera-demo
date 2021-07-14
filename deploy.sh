#!/bin/bash

# Normally we'd use `lamdera deploy` but
# we run into 2 issues in our use case.
# The first

lamdera check

GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa' git push lamdera main:master