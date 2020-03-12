#!/bin/bash
# INITIAL STEPS
# 1. create a folder for your project;
# 2. cd into the folder;
# 3. run the script.
#
# To run the script, simply type `sh myScript.sh` in your terminal inside your
# project's root. Example:
# $ sh myScript.sh

# Display welcome message
echo
echo "============================================"
printf "\e[92mWELCOME TO WORDPRESS INSTALL!\e[0m\n"
echo
echo "This script downloads and installs a fresh 
copy of Wordpress in the current directory."
echo "============================================"
echo
echo "First, we'll get some info..."
echo
# Set database name 
printf "Database name: "
read -r dbname
# Set user name
printf "Database user: "
read -r dbuser
# Set database password
printf "Database password: "
read -r dbpassword
echo
# Ask which version of Wordpress to install
echo "Which version of Wordpress do you want to install?
1 - Version 5.3.2 (latest)
2 - Version 5.3.1 
3 - Version 5.3"
while :
printf "Enter your choice: "
do
    read -r version
    case $version in
        1)
            wp_v=5.3.2
            echo "You chose wordpress-5.3.2"
            break
            ;;
        2)
            wp_v=5.3.1
            echo "You chose wordpress-5.3.1"
            break
            ;;
        3)
            wp_v=5.3
            echo "You chose wordpress-5.3"
            break
            ;;
        *)
            echo "Invalid input. Try again."
            ;;
    esac
done
# Wordpress file variable with selected version
WP_FILE=wordpress-${wp_v}.tar.gz
echo
# Ask for confirmation to install Wordpress
printf "Run install? \e[92m(y/n)\e[0m : "
read -r run
# if 'n', stop script and exit program
if [ $run == n ]
    then exit
# otherwise, proceed to install and print alert message to terminal
else
    echo "Please, wait while Wordpress is getting installed.\n"
# change text color of download output to the terminal
printf "\e[35m"
# download Wordpress and prevent files from being outputted to the terminal
# running this command, this will create a zip file in the current directory 
# and download the selected version of Wordpress
curl -O https://wordpress.org/${WP_FILE}
printf "\e[0m"
# unzip the Wordpress install folder
tar -zxf $WP_FILE
# cd into the wordpress directory
cd wordpress
# copy everything to parent directory
cp -rf . ..
# go back to parent directory
cd ..
# remove files from the wordpress folder
rm -R wordpress
# create a new wp-config.php file using wp-config-sample.php
cp wp-config-sample.php wp-config.php
# set the database credetials
# to do so, we'll use perl to find and replace the correct lines
perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
perl -pi -e "s/username_here/$dbuser/g" wp-config.php
perl -pi -e "s/password_here/$dbpass/g" wp-config.php
# set up Wordpress salts to keep the site secure
# we'll use perl again to update the correct values
perl -i -pe'
    BEGIN {
        @chars = ("a" .. "z", "A" .. "Z", 0 .. 9);
        push @chars, split //, "!@#$%^&*()-_ []{}<>~\`+=,.;:/?|";
        sub salt { join "", map $chars[ rand @chars ], 1 .. 64 }
    }
    s/put your unique phrase here/salt()/ge
' wp-config.php
# create the uploads folder inside the new Wordpress project
mkdir wp-content/uploads
# set permissions, we'll use chmod to 'change mode' and '775' is giving
# permissions to a specific folder
chmod 775 wp-content/uploads
# print message to the terminal to let user know things are happening
# behind the scenes 
echo "Doing some spring cleaning..."
# remove the zip file from the current directory
rm $WP_FILE
# all steps have been completed, say goodbye
echo
printf "\e[92mWordpress installation is complete!\e[0m\n"
echo "Goodbye!"
fi
