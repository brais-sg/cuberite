 #!/usr/bin/env bash

set -e

export MCSERVER_BUILD_SERIES_NAME="Travis $CC $TRAVIS_MCSERVER_BUILD_TYPE"
export MCSERVER_BUILD_ID=$TRAVIS_JOB_NUMBER
export MCSERVER_BUILD_DATETIME=`date`

if [ "$CXX" == "g++" ]; then
	# This is a temporary workaround to allow the identification of GCC-4.8 by CMake, required for C++11 features
	# Travis Docker containers don't allow sudo, which update-alternatives needs, and it seems no alternative to this command is provided, hence:
	export CXX="/usr/bin/g++-4.8"
fi
cmake . -DBUILD_TOOLS=1 -DSELF_TEST=1;
make -j 2;
make -j 2 test ARGS="-V";
cd MCServer/;
if [ "$TRAVIS_MCSERVER_BUILD_TYPE" != "COVERAGE" ]; then
	echo restart | $MCSERVER_PATH;
	echo stop | $MCSERVER_PATH;
fi
