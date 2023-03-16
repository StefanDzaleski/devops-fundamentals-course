#!/bin/bash - 
#===============================================================================
#
#          FILE: build-client.sh
# 
#         USAGE: ./build-client.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: STEFAN DJALESKI
#  ORGANIZATION: 
#       CREATED: 03/16/2023 04:03:05 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# install npm dependencies
npm i

# check if a dist.zip file exists, if it does, delete it
if [[ -d dist.zip ]]; then
	rm -rf dist.zip
fi

# run the build with production flag
npm run build --configuration=production

# zip the generated dist file
zip dist.zip dist

