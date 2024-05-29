NTFS Patcher makes it easy to run Windows games on NTFS partitions by "bypassing" restrictions on running binaries on NTFS drives.

How it works:

The user runs the script, a window will ask the user to choose the game directory, and then the root password will be provided (the bypass is done by copying the .exe to /tmp, applying the run flag, and "mounting" the new .exe in the old path), hence the need to run as root.


TODO:
After the reboot, the actions are undone, we are working on it.
