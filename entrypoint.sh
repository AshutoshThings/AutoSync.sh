#!/bin/bash

# Start cron service
service cron start

# Keep container alive
tail -f /dev/null
