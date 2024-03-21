#!/bin/bash

# Start the first process
php83 -S 0.0.0.0:3001 /root/index.php &

# Start the second process
nginx -g "daemon off;" &

# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
