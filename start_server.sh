#!/bin/bash
# start_server.sh

# Ensure the script runs as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Navigate to the application directory
APP_DIR="/var/www/html"
cd "$APP_DIR" || exit

# Start the application based on the tech stack
# For a Node.js app:
if [ -f package.json ]; then
  echo "Starting Node.js application... 🟢"
  nohup npm start > app.log 2>&1 &
fi

# For a Python app:
if [ -f app.py ]; then
  echo "Starting Python Flask application... 🐍"
  nohup python3 app.py > app.log 2>&1 &
fi

# For a PHP app:
if [ -f index.php ]; then
  echo "Starting Apache server for PHP application... 🌐"
  sudo systemctl restart httpd
fi

# Confirm the application is running
echo "Application started! 🚀"
