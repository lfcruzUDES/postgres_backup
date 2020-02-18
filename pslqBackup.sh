#!/bin/bash
# Makes a backup from a postgres db, also this script can restore that db.
# Author: Luis Fernando Cruz Carrillo
# Emails: lfcruz@udes.edu.mx | quattrococodrilo@gmail.com

# Put here your db name.
dbname=$DBNAME
user=$USERDB
# Put here your path to backups depot.
backupDir=$BACKUPDIR
date=$(date +"%Y%m%d%H%M%S")

backupDir_exists(){
    if [ ! -d $backupDir ]; then
        mkdir -p $backupDir
    fi
}

backup(){
    backupDir_exists
    read -s -p "Enter root password: " pswd
    echo "$pswd"|sudo -S -u postgres pg_dump -Fc $dbname > "$backupDir/$dbname$date.dump"
    if [ $? -eq 0 ]; then
        echo "Backup OK"
    else
        echo "Somthing was wrong!"
    fi
    echo -e "\n"
    read -n 1 -s -r -p "Press enter to continue..."
}

restore(){
    ls -tlah $backupDir
    read -p "Backup name: " backupName
    echo "$backupDir/$backupName"
    if [ -f "$backupDir/$backupName" ]; then
        read -s -p "Enter root password: " pswd
        echo "$pswd"|sudo -S -u postgres pg_restore --verbose --clean --no-acl --no-owner -h localhost -U $user -d $dbname "$backupDir/$backupName"
    else
        echo "backup file not exists!"
    fi
}

if [ $# -eq 0 ]; then
    echo "Enter a valid option:"
    echo "---------------------"
    echo "-bak for create a backup"
    echo "-rest for restore a backup"
    exit 1
fi

if [ $1 = '-bak' ]; then
    backup
elif [ $1 = '-rest' ]; then
    restore
else
    echo "Option not valid."
fi
