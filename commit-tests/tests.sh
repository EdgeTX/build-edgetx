#!/bin/bash

source /opt/qt$QT_BASE/bin/qt$QT_BASE-env.sh

# LeakSanetizer needs to be disabled on docker,
# or container run with '--privileged'
export ASAN_OPTIONS=detect_leaks=0

cd /src && \
    FLAVOR=COMPANION ./tools/commit-tests.sh && \
    FLAVOR=ARM9X     ./tools/commit-tests.sh && \
    FLAVOR=X9LITE    ./tools/commit-tests.sh && \
    FLAVOR=X7        ./tools/commit-tests.sh && \
    FLAVOR=XLITE     ./tools/commit-tests.sh && \
    FLAVOR=X9        ./tools/commit-tests.sh && \
    FLAVOR=COLORLCD  ./tools/commit-tests.sh
