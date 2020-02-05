#!/bin/bash
# Sync db.bak files with remote host in the same network. 
# Requires rsync
# Author: Luis Fernando Cruz Carrillo
# Email: lfcruz@udes.edu.mx - quattrococodrilo@gmail.com

backupDir=""
remoteDir=""
user=""
host=""

lastback=$(find $backupDir -type f -printf '%T@ %p\n' | sort -n | tail -1 | cut -f2- -d" ")

rsync -avz $lastback $user@$host:$remoteDir