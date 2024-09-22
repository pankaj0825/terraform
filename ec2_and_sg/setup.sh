#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
echo "<h1>hi this is Web Server $(hostname)</h1>" | sudo tee /var/www/html/index.html
sudo systemctl restart apache2
sudo systemctl enable apache2