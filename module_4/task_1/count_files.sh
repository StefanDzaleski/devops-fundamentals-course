#!/usr/bin/env bash

#the input is expected to be in the format such as ., ./file1, ./file1/file2 etc

#initialize a count variable to store the number of files
count=0

#create a function that will count the number of files in a directory
#and each of its subdirectories
countfiles() {
#the function will receive one arguemnt which is the path of the directory
    for i in $1; do
    #check if it is a directory, if it is, count the files inside it
        if [[ -d "$i" ]];then
            countfiles "$i/*"
        else
    #otherwise increase the count of files
            ((count++))
        fi;
    done
}

#do this for every argument provided
for j in "$@"
do
    countfiles "$j/*"
    echo "There are $count files in $j and it's subdirectories"
    count=0
done
