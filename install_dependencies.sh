#!/bin/bash
# install_dependencies.sh

# Ensure the script runs as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

# Update package lists
echo "Updating package lists... 📦"
sudo yum update -y

# Install essential packages
echo "Installing essential packages... ⚙️"
sudo yum install -y git curl unzip

# Install web server (e.g., Nginx or Apache)
echo "Installing web server... 🌐"
sudo yum install -y httpd  # For Apache (you can replace with nginx if needed)

# Start and enable the web server
echo "Starting and enabling the web server... 🚀"
sudo systemctl start httpd
sudo systemctl enable httpd

# Install Node.js (if your application is Node.js-based)
echo "Installing Node.js... 🟢"
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Install Python (if needed)
echo "Installing Python and pip... 🐍"
sudo yum install -y python3 python3-pip

# Clone the application repository
echo "Cloning application repository... 🛠️"
git clone https://github.com/<your-repo>/<your-app>.git /var/www/html

# Navigate to the application directory
cd /var/www/html || exit

# Install Node.js dependencies (if any)
if [ -f package.json ]; then
  echo "Installing Node.js dependencies... 📦"
  npm install
fi

# Install Python dependencies (if any)
if [ -f requirements.txt ]; then
  echo "Installing Python dependencies... 📘"
  pip3 install -r requirements.txt
fi

echo "Dependencies installed successfully! ✅"
