#!/bin/bash

# Update package lists
sudo apt update

# Install LAMP stack dependencies
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql git

# Enable Apache modules
sudo a2enmod rewrite

# Clone the PHP application from GitHub (replace with your repository URL)
git clone https://github.com/laravel/laravel.git /var/www/html/laravel

echo "repo cloned successfully"

# Set permissions
chown -R www-data:www-data /var/www/html/laravel
chmod -R 755 /var/www/html/laravel

# Configure Apache virtual host
echo "<VirtualHost *:80>
  DocumentRoot /var/www/html/laravel/public
  <Directory /var/www/html/laravel/public>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
  </Directory>
</VirtualHost>" > /etc/apache2/sites-available/laravel.conf

# Enable the application virtual host configuration
a2ensite laravel.conf

# Restart Apache to apply changes
systemctl restart apache2

# Configure MySQL (optional: create a database and user)
mysql -u root -e "CREATE DATABASE IF NOT EXISTS laravel_db;"
mysql -u root -e "CREATE USER IF NOT EXISTS 'admin'@'localhost' IDENTIFIED BY 'admin';"
mysql -u root -e "GRANT ALL PRIVILEGES ON laravel_db.* TO 'admin'@'localhost';"
mysql -u root -e "FLUSH PRIVILEGES;"

# Display completion message
echo "LAMP stack deployed successfully!"
