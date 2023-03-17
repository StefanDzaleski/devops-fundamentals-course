#!/bin/bash - 
#===============================================================================
#
#          FILE: update-pipeline-definition.sh
# 
#         USAGE: ./update-pipeline-definition.sh 
# 
#   DESCRIPTION: 
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: STEFAN DJALESKI 
#  ORGANIZATION: 
#       CREATED: 03/13/2023 05:49:33 PM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# check if jq is installed
# if it is not, print instructions on how to install it
if ! command -v jq &> /dev/null
then
    echo "jq command is not found"
    echo
    echo "To install jq on Debian and Ubuntu use: sudo apt-get install jq"
    echo
    echo "To install jq on Fedora use: sudo dnf install jq"
    echo
    echo "To install jq on openSUSE use: sudo zypper install jq"
    echo
    echo "To install jq on Arch use: sudo pacman -S jq"
    echo
    echo "To install jq on OS X use: brew install jq"
    echo
    echo "To install jq on Windows use: chocolatey install jq"
    exit
fi

# check if path to original pipeline.json is provided
if [ $# -lt 1 ]; then
  echo "Please provide a path to the pipeline file"
  exit 1
fi

# path to original file
originalpipeline=$1

# check if the path provided is an actual JSON file
if [[ ! $originalpipeline =~ \.json$ ]]; then
  echo "Please provide a valid path to a json file"
  exit 1
fi

# path to the new file that will be created
newpipeline="pipeline-$(date +%Y-%m-%d-%H-%M-%S).json"

# path to temp file to store the outputs from jq commands
temporaryfile="temp.json"

touch $newpipeline
touch $temporaryfile

cp $originalpipeline $newpipeline

# shift so that we loop through the options provided (if any)
shift

updatemetadata() {
  checkexistance=$(jq '.metadata' $newpipeline)

  if [[ $checkexistance == "null" ]]; then
    echo "Property does not exist in provided JSON"
    exit 1
  fi

  jq "del(.metadata)" $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline

  checkexistance=$(jq '.pipeline.version' $newpipeline)
  
  if [[ $checkexistance == "null" ]]; then
    echo "Property does not exist in provided JSON"
    exit 1
  fi

  jq ".pipeline.version += 1" $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline
}

updatemetadata

# initial values
branch="main"
poll=false

updatebranch() {
jq --arg branch "$branch" '.pipeline.stages[0].actions[0].configuration.Branch = $branch' $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline
}

updateowner() {
jq --arg owner "$owner" '.pipeline.stages[0].actions[0].configuration.Owner = $owner' $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline
}

updaterepo() {
jq --arg repo "$repo" '.pipeline.stages[0].actions[0].configuration.Repo = $repo' $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline
}

updatepoll() {
jq --arg poll "$poll" '.pipeline.stages[0].actions[0].configuration.PollForSourceChanges = $poll' $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline
}

updateconfiguration() {
envvariables=$(jq --arg configuration "$configuration" '.pipeline.stages[1].actions[0].configuration.EnvironmentVariables | fromjson | .[0].value = $configuration | tojson' $newpipeline)

jq --arg envvariables "$envvariables" '.pipeline.stages[1].actions[0].configuration.EnvironmentVariables = $envvariables' $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline

envvariables=$(jq --arg configuration "$configuration" '.pipeline.stages[3].actions[0].configuration.EnvironmentVariables | fromjson | .[0].value = $configuration | tojson' $newpipeline)

jq --arg envvariables "$envvariables" '.pipeline.stages[3].actions[0].configuration.EnvironmentVariables = $envvariables' $newpipeline > $temporaryfile && mv $temporaryfile $newpipeline
}

#check if there are any arguments in the script and loop over them
while [ $# -ge 1 ] && [ -n $1 ]; do
  case $1 in
    --branch)
      branch=$2
      updatebranch;;
    --owner)
      owner=$2
      updateowner;;
    --repo)
      repo=$2
      updaterepo;;
    --poll-for-source-changes)
      poll=$2
      updatepoll;;
    --configuration)
      configuration=$2
      updateconfiguration;;
    *)
      break
  esac

  shift 2
done


