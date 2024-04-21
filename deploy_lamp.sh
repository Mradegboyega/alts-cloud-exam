#!/bin/bash

# Update package lists
sudo apt update

# Upgrade PHP to a newer version
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:ondrej/php
sudo apt update
sudo apt install -y php8.3 php8.3-{mysql,xml,dom,curl}

# Set non-interactive mode for package installation
export DEBIAN_FRONTEND=noninteractive

# Install LAMP stack dependencies
sudo apt install -y apache2 mysql-server git

# Enable Apache modules
sudo a2enmod rewrite

# Install Composer (if not already installed)
if ! command -v composer &> /dev/null
then
    # Download and install Composer
    sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer
    sudo rm composer-setup.php
fi

# Clone the PHP application from GitHub (replace with your repository URL)
if [ ! -d "/var/www/html/laravel" ]; then
    git clone https://github.com/laravel/laravel.git /var/www/html/laravel
else
    echo "Laravel directory already exists, skipping clone."
fi

# Set permissions
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel

# Set permissions for vendor directory
sudo chmod -R 777 /var/www/html/laravel/vendor

# Set permissions for storage/logs directory
sudo chmod -R 777 /var/www/html/laravel/storage/logs

# Set permissions for bootstrap/cache directory
sudo chmod -R 777 /var/www/html/laravel/bootstrap/cache

# Run composer install
cd /var/www/html/laravel
composer install

# Configure Apache virtual host
sudo tee /etc/apache2/sites-available/laravel.conf > /dev/null <<EOF
<VirtualHost *:80>
  DocumentRoot /var/www/html/laravel/public
  <Directory /var/www/html/laravel/public>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>
EOF

# Enable the application virtual host configuration
sudo a2ensite laravel.conf

# Restart Apache to apply changes
sudo systemctl restart apache2

# Configure MySQL (optional: create a database and user)
sudo mysql -u root <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS laravel_db;
CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON laravel_db.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Display completion message
echo "LAMP stack deployed successfully!"
