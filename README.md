# 🚀 AutoSync.sh
## A Docker-powered, automated cloud sync engine for Google Drive + Local Folder
<p align="center"> <img src="https://img.shields.io/badge/Platform-Docker-blue?logo=docker&style=for-the-badge"> <img src="https://img.shields.io/badge/Sync-Rclone-brightgreen?logo=google-drive&style=for-the-badge"> <img src="https://img.shields.io/badge/Scheduler-Cron-orange?style=for-the-badge"> <img src="https://img.shields.io/badge/Logs-AutoRotate-yellow?style=for-the-badge"> <img src="https://img.shields.io/github/license/AshutoshThings/AutoSync.sh?style=for-the-badge"> </p> <p align="center"> <b>Automatic • Containerized • Secure • Real-time File Synchronization</b><br> Runs everywhere with Docker. Keeps your Google Drive folder & local folder in perfect sync. </p>

## Features
#### 1. Two-Way Sync (Local ↔ Google Drive)
-  Local → Cloud upload
-  Cloud → Local mirror download
-  Runs every minute using cron

#### 2. Automatic Log Rotation
- Compresses old logs
- Deletes old logs
-  Prevents storage bloat

#### 3. Fully Dockerized
- No cron or rclone setup on the host
- Works identically on macOS / Linux / Windows

#### 4. Secure
- Rclone config stays inside the container
- Nothing sensitive committed to GitHub

#### 5. Lightweight & Offline-Friendly
- Only syncs changed files
- Works without GUI
- Extremely low resource usage

## Architecture

```
+------------------------------+
|        Docker Container       |
|------------------------------|
| Cron + Rclone + Scripts      |
+--------------+---------------+
               |
   Every minute| 
               ▼
  +--------------------------+
  | autosync.sh              |
  | Upload local → GDrive    |
  +--------------------------+
               |
               ▼
  +--------------------------+
  | rclone sync (mirror)     |
  | GDrive:backup → local    |
  +--------------------------+
               |
     Nightly at 12 AM
               ▼
  +--------------------------+
  | logrotate.sh             |
  | Compress + cleanup logs  |
  +--------------------------+
```

## Project Structure 

```
AutoSync/
├── Dockerfile
├── README.md
├── entrypoint.sh
├── scripts/
│   ├── autosync.sh
│   ├── logrotate.sh
│   └── crontab.txt
├── drive_folder/        # Google Drive mirror
├── local_folder/        # Upload source
├── logs/                # Script logs
└── .gitignore
```

## Installation Guide

#### 1. Clone the Repository
```
git clone https://github.com/AshutoshThings/AutoSync.sh
cd AutoSync.sh
```
#### 2. Build Docker Image
```
docker build -t autosync .
```
#### 3. Run Container
```
docker run -it --name autosync-container autosync
```
#### 4. Configure Rclone (do it very carefully)
```
rclone config
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

copy this and paste into your terminal to authenticate yourself to rclone.
```
Test yourself
```
rclone ls gdrive2024:
```
If you see files → you're done.

#### 5. Exit & Start as Background Service
```
exit
docker start autosync-container
```
Logs:
```
docker logs -f autosync-container
```

### Scripts Overview
 > autosync.sh
- Uploads changed files
- Writes logs
- Handles network errors
> logrotate.sh
- Compresses yesterday’s logs
- Deletes logs older than N days
- Keeps container storage clean
> crontab.txt
- Defines all jobs (sync & log rotation)
> entrypoint.sh
- Starts cron in the foreground.

### Security Considerations
- Rclone config stored inside container only
- Tokens can be revoked any time from Google Security Dashboard

## Testing
#### Test syncing upload:
```
echo "hello" > local_folder/test.txt
```
Within 1 minute:
``` test.txt ``` should appear in Google Drive.
### Test download mirror:
Add a file in Google Drive → backup folder
→ it appears automatically in drive_folder/
___
## License - Unlicense 
<p align="center">
  <img src="https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExdTVlNzIwcmZpZmk1Y29vN2hxZTFpeXF2NHYyOXNyMWw0NGx5M3l2NSZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/5xaOcLGvzHxDKjufnLW/giphy.gif" width="380">
  <br>
  <i>It is free bro, do whatever you want with it. if you liked like, just give it a star, that's all.</i>
</p>

