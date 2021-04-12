#!/bin/bash

# Set Qt environment variables
source /opt/qt$QT_BASE/bin/qt$QT_BASE-env.sh

# LeakSanetizer needs to be disabled on docker,
# or container run with '--privileged'
export ASAN_OPTIONS=detect_leaks=0

# Then run the CMD
exec "$@"
