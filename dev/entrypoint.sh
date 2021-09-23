#!/bin/bash

# LeakSanetizer needs to be disabled on docker,
# or container run with '--privileged'
export ASAN_OPTIONS=detect_leaks=0

# Then run the CMD
exec "$@"
