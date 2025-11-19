FROM ubuntu:latest

# Install dependencies
RUN apt update && apt install -y \
    rclone \
    cron \
    nano \
    findutils \
    coreutils

# Create directory structure
RUN mkdir -p /home/ubuntu/AutoSync/local_folder \
             /home/ubuntu/AutoSync/scripts \
             /home/ubuntu/AutoSync/logs

# Copy scripts into container
COPY scripts/autosync.sh /home/ubuntu/AutoSync/scripts/autosync.sh
COPY scripts/logrotate.sh /home/ubuntu/AutoSync/scripts/logrotate.sh

# Install crontab
COPY scripts/crontab.txt /etc/cron.d/autosync-cron

RUN chmod 0644 /etc/cron.d/autosync-cron && \
    crontab /etc/cron.d/autosync-cron


# Make scripts executable
RUN chmod +x /home/ubuntu/AutoSync/scripts/*.sh

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Start cron on container boot
CMD ["/entrypoint.sh"]
