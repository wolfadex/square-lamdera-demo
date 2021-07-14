#!/bin/bash

# Normally we'd use `lamdera deploy` but
# we run into 2 issues in our use case.
# The first is that we _must_ use RSA for
# Lamdera SSH keys. The second is that
# Lamdera only supports a "master" branch
# currently (though it's being changed).

lamdera check

GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa' git push lamdera main:master