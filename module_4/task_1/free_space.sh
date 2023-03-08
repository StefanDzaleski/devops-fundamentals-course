#!/usr/bin/env bash

# set default limit
limit=10000000

#check if there is an argument to update the limit
if [ ! -z $1 ]
then
    limit=$1
fi

while true
do
    # get the freespace in kbs
    freespace=$(df / | awk '{print $4}' |tail -1)
    
    #check if the freespace is less than the limit
    if (($limit > $freespace))
    then
        echo "You don't have enough free space!"
    fi
    
done