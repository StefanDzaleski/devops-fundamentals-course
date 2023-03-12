#!/usr/bin/env bash

datafilepath="../data/users.db"

#get the option parameter
inversefile=$2

#check if the file exists, otherwise create it
checkfileexistance() {
    if [[ ! -e "../data/users.db" ]]; then
        read -p "File does not exist. Do you want to create it? [y/n] " create
        while [[ "$create" != "y" ]] && [[ "$create" != "n" ]]
        do
            read -p "Please answer with y or n " create
        done
        
        if [[ "$create" == "y" ]]; then
            touch $datafilepath
        else
            echo "You need to create a users.db file to continue";
            exit 1
        fi
    fi
}

#add a username and role to the users.db file
add() {
    checkfileexistance
    
    pattern="^[A-Za-z]+$"
    
    read -p "Please enter a username: " username
    while [[ ! $username =~ $pattern ]]
    do
        read -p "Please enter only latin letters: " username
    done
    
    read -p "Please enter a role: " role
    while [[ ! $role =~ $pattern ]]
    do
        read -p "Please enter only latin letters: " role
    done
    
    echo "$username, $role" >> $datafilepath
}

#create a backup file with the date in the name 
backup() {
    cp $datafilepath "../data/$(date +%Y-%m-%d-%H-%M-%S)-users.db.backup"
}

#get the last backup made and replace it with the users.db
restore() {
    latestbackup="$(ls ../data/*.db.backup | tail -1)";
    
    if [[ ! -f $latestbackup ]]; then
        echo "no backup"
        exit 1
    fi
    
    cat $latestbackup > $datafilepath
}

#find a user with the given username and print out all found users
find() {
    read -p "Please enter a username: " username
    
    usersfound=$(grep -n ${username}, $datafilepath | sed -r 's/:/. /g')
    
    if [[ -z $usersfound ]]; then
        echo "User not found."
        exit 1
    fi
    
    echo "$(grep -n ^${username}, $datafilepath | sed -r 's/:/. /g')"
}

#list the contents of the users.db file
#if the --inverse parameter is passed, list the in reverse order
list() {
    if [[ $inversefile = "--inverse" ]]; then
        awk '{print NR"." ,$0}' $datafilepath | tac
        exit 1
    fi
    
    awk '{print NR"." ,$0}' $datafilepath
}

#list the help contents of the script
help() {
    echo "For each command other than help, a users.db file needs to be created for the script to work"
    echo "If no file is created, the script will exit."
    echo
    echo "Command add: Adds a new user and role for the user to users.db."
    echo "Both username and role have to be provided when prompted."
    echo "Both username and role can contain only latin characters."
    echo
    echo "Command backup: Creates a copy of users.db with the date when it was created."
    echo
    echo "Command restore: Replaces the current users.db file with the most recent backup."
    echo "There has to be at least one backup present for this to work."
    echo
    echo "Command find: Promts for a username and finds all occurances of that username in the users.db file."
    echo
    echo "Command list: Lists the contents of the users.db file."
    echo "An additional option --inverse may be provided to the list command."
    echo "If the --inverse option is provided, the contents will be listed in inverse order."
    echo
    echo "Command help (or no command at all): Prints instructions on how to use the script."
}

case $1 in
    "add") add;;
    "backup") backup;;
    "restore") restore;;
    "find") find;;
    "list") list;;
    "help") help;;
    *) help;;
esac