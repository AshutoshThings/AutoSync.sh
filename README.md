# AutoSync.sh
A Linux-native, event-driven cloud synchronization tool for Google Drive and Local Folders

AutoSync.sh is a background service that monitors your local files in real-time and ensures they stay in perfect harmony with Google Drive. Unlike traditional cron-based syncs that run on a timer, this tool uses kernel-level event triggers to act the moment a file is touched.

## Features 
1. Real-Time File Change Monitoring (uses `inotify-tools`)
2. GDrive 2-Way Sync (uses `rclone bisync`)
3. Automatically starts on boot and the life cycle can be managed by `systemd` service commands.
4. Optimization :
  - If a file is saved multiple times in quick succession, the script waits for a 5-second quiet period before syncing to save bandwidth and API     hits.
  - Every 3 minutes, the daemon checks for remote changes from Google Drive silently, ensuring logs remain clean unless an actual transfer or        error occurs.

## Project Structure 
```
AUTOSYNC.SH/
├── bin/
│   └── autosync         # core daemon
├── config/
│   └── autosync.conf    # Local configuration
├── docker/              # Development support
│   ├── compose.yaml
│   └── Dockerfile
├── scripts/
│   └── logrotate.sh     # log manager
├── systemd/
│   └── autosync.service # for background persistence
├── .gitignore           
├── autosync.log         
├── install.sh           # installer
├── LICENSE             
└── README.md            # Project documentation (Must read before starting setup)
```

## Installation Guide(for users):
1. Clone the Repo :
   ```
      git clone https://github.com/AshutoshThings/AutoSync.sh.git
      cd AutoSync.sh
   ```
2. Run the installer: `./install.sh`
3. Create the Remote(rclone configuartion) :
   ```
    new remote           > n
    Storage              > 18 (for google drive)
    client ID            > skip
    Scope                > 1
    edit advanced config > n
    use auto config      > n
    config this as shared drive > n
    keep this "gdrive2024(whatever name you gave)" remote > y
    save this config and for verification of rclone with google drive you will have to execute a command something like this rclone authorize "drive" "eyJzY...." into your computer terminal which will pop up your browser which then you will have to verify with your login credentials then you go back to the termianl and you will get long random text some like this : Paste the following into your remote machine --->
    eyJ0b2tlX............2KzA1OjMwXCIsXCJleHBpcmVzX2luXCI6MzU5OX0ifQ
    <---End paste
    Copy this and paste it into your terminal to authenticate yourself to rclone.

   Once the remote is created, tell AutoSync which local folder you want to sync
   and the tell where autosync should sync the files on your Google Drive (i.e., your newly created remote)
    ```
4. That's it, configuration done.
   
5. To Test : go to the file you told autosync to monitor locally, paste something into that folder and see it automatically get uploaded you                   your google drive.

## Contribution - Replicate Development Environment (for Developers)

(will update soon...🤞)
I have used docker so yeah run Docker build command.


## License - Unlicense 
<p align="center">
  <img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExdTVlNzIwcmZpZmk1Y29vN2hxZTFpeXF2NHYyOXNyMWw0NGx5M3l2NSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/5xaOcLGvzHxDKjufnLW/giphy.gif" width="380">
  <br>
  <i>It is free bro, do whatever you want with it. if you liked this, just give it a star, that's all.</i>
</p>

