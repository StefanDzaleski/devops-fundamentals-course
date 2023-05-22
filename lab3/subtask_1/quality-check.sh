#!/bin/bash - 
#===============================================================================
#
#          FILE: quality-check.sh
# 
#         USAGE: ./quality-check.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: STEFAN DJALESKI
#  ORGANIZATION: 
#       CREATED: 03/16/2023 04:06:29 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

CLIENT_HOST_DIR=$(pwd)/../shop-angular-cloudfront

cd $CLIENT_HOST_DIR

# store the result of the linting in a variable so that it can be printed out
# in case there is an error
lintresult=$(ng lint)

# check if there is an error in files that have been linted
# if so, print out the result
if [[ $? == 1 ]]; then
	echo $lintresult
fi

# run the tests
ng test --watch=false

npm audit

