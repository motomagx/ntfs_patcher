#!/bin/bash

HOME_DIR=""
GAME_DIRECTORY=""

# Receives the new HOME_DIR and GAME_DIRECTORY path if given as an argument (used in case of re-execution as root (see below))
if [ "x$1" != "x" ]
then	# Root mode:
	HOME_DIR="$1"
	GAME_DIRECTORY="$2"

else	# User mode:

	HOME_DIR="$HOME/.ntfs_patcher/"
	mkdir -p "$HOME_DIR/mounts"
	
	if [ ! -f "$HOME_DIR/last_dir.txt" ]
	then
		LAST_DIR="$HOME"
	else
		LAST_DIR=$( cat "$HOME_DIR/last_dir.txt" )
	fi
	
	GAME_DIRECTORY=$( zenity --file-selection --directory --filename=$LAST_DIR/ )

	# Exit if user cancel dir selection
	if [ $? != 0 ]
	then
		exit
	else
		# Update last_dir:
		echo "$GAME_DIRECTORY" > "$HOME_DIR/last_dir.txt"
	fi
fi

# It needs to be ROOT because the "mount" command does not allow "bind" without being root.
if [ $USER != "root" ]
then
	# Re-run script as rudo:

	SCRIPT_NAME=$(basename "$0")
	pkexec "$PWD"/"$SCRIPT_NAME" "$HOME_DIR" "$GAME_DIRECTORY"
	exit
fi

# ===============================================================================


# Gen list files:

MOUNTPOINT_ID="$RANDOM$RANDOM$RANDOM"
find "$GAME_DIRECTORY" | grep -i '[.]exe' > "$HOME_DIR/mounts/$MOUNTPOINT_ID.txt"
LINES=$( cat "$HOME_DIR/mounts/$MOUNTPOINT_ID.txt" | wc -l )
LINES=$(($LINES+1))

COUNTER=1

while [ "$COUNTER" != "$LINES" ]
do
	P="p"
	EXE_PATH=$( sed -n $COUNTER$P "$HOME_DIR/mounts/$MOUNTPOINT_ID.txt" )
	EXE_FILENAME=$(basename "$EXE_PATH")

	mkdir -p "/tmp/ntfs_patcher/$MOUNTPOINT_ID"
	
	cp "$EXE_PATH" "/tmp/ntfs_patcher/$MOUNTPOINT_ID"/

	chmod +x "/tmp/ntfs_patcher/$MOUNTPOINT_ID/$EXE_FILENAME"
	
	mount -o bind "/tmp/ntfs_patcher/$MOUNTPOINT_ID/$EXE_FILENAME" "$EXE_PATH"
		
	echo "Mount: /tmp/ntfs_patcher/$MOUNTPOINT_ID/$EXE_FILENAME as $EXE_PATH"
	
	COUNTER=$(($COUNTER+1))
done



















