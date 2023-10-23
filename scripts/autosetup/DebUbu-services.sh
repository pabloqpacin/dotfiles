#!/bin/bash

echo -e "\n----################################################################----"
echo -e "#######~~~~~{     DebUbu-services v1.1  by @pabloqpacin    }~~~~~#######"
echo -e "----################################################################----\n"

### Tested successfully on Ubuntu 22.04 (fresh VM post DebUbu-base):
### curl https://raw.githubusercontent.com/pabloqpacin/dotfiles/main/scripts/autosetup/DebUbu-services.sh \
### -o services.sh && chmod +x services.sh && ./services.sh

################################################################################
#                                  FUNCTIONS                                   # 
################################################################################

function log_df_services {
    date >> $df_log_services
    echo -e "Currently installed packages: $(dpkg -l | wc -l)" >> $df_log_services
    df -h >> $df_log_services; echo -e "\n" >> $df_log_services
}

function secs_to_mins {
    local total_seconds="$1"
    local minutes=$((total_seconds / 60))
    local seconds=$((total_seconds % 60))
    end_time_minutes="$minutes:$seconds"
}

function system_update {
    echo -e "${YELLOW}########## Updating ${RED}${BOLD}apt${RESET}${YELLOW} packages ####################${RESET}"
    if [ ! -e "/etc/apt/apt.conf.d/99show-versions" ]; then
        echo 'APT::Get::Show-Versions "true";' | sudo tee /etc/apt/apt.conf.d/99show-versions
    fi
    sudo apt-get update && \
        sudo apt-get upgrade -y && \
        sudo apt-get autoremove -y && \
        sudo apt-get autoclean -y
}

# function install_mysql_wb_deb {
# }

function install_mysql_wb_ubupop {
    if ! command -v mysql &>/dev/null; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}mysql-server${RESET}${YELLOW} ####################${RESET}"
        wget https://dev.mysql.com/get/mysql-apt-config_0.8.26-1_all.deb
        read -p "== Expect an interactive menu. Defaults are fine. Press any key. == " null
        sudo dpkg -i mysql-apt-config_0.8.26-1_all.deb
        echo ""; read -p "== Expect an interactive menu. Set a strong root password. Press any key. == " null
        $sa_update && $sa_install mysql-server
        systemctl status mysql; systemctl is-enabled mysql
        # $sa_install mysql-workbench-community
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}mysql-server${RESET}${YELLOW} is already installed ##########${RESET}"
    fi
}

function config_mysql {
    if command -v mysql &>/dev/null && [[ ! -e $mysql_conf ]]; then
        echo -e "\n${YELLOW}########## ${RED}${BOLD}mysql-server${RESET}${YELLOW} initial configuration ####################${RESET}"
        echo -e "\n== Writing '$mysql_conf' to set the following default prompt =="
        echo -e "${CYAN}[12:40] username@localhost (database)>${RESET} show databases;\n"
        echo -e '[mysql]\nprompt = "[\R:\m]\_\U\_(\d\T)>\_"\n; pager = "bat"' | sudo tee $mysql_conf
        echo -e "\n== Let's create the ${CYAN}new user${RESET} '${BOLD}$USER${RESET}' for mysql-server =="
        local password_user="0"; local password_check="1"
        while [[ $password_user != $password_check ]]; do
            read -sp "Enter the password for the new user: " password_user; echo ""
            read -sp "Re-enter the password: " password_check; echo ""
            if [[ $password_user != $password_check ]]
                then echo -e "${RED}Error${RESET}: the passwords don't match. Please try again.\n"
                else echo -e "${GREEN}Success${RESET}! The password for '${BOLD}$USER${RESET}' has been set.\n"
            fi
        done
        echo -e "CREATE USER $USER@localhost IDENTIFIED BY '$password_user';\nGRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON *.* TO $USER@localhost;" > $script_sql
        echo -e "== Enter the mysql 'root' password (required atm to create a new user) =="
        mysql -u root -p -e "source $script_sql"
        if [[ $? == 0 ]]
            then echo -e "${GREEN}Success!${RESET}" && rm $script_sql
            else echo -e "${RED}Something went wrong... 🤸${RESET}"; return
        fi
        echo -e "\n== Connect as '${BOLD}$USER${RESET}' to 'select user,host from mysql.user' =="
        mysql -u $USER -p -e "select user,host from mysql.user;"
        echo -e "\n== Great. From now on, you could just type '${BOLD}mysql -p${RESET}' to log in ==\n"
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}$mysql_conf${RESET}${YELLOW} already exists ##########${RESET}"
    fi
}

# # https://www.nginx.com/resources/wiki/start/topics/recipes/wordpress/
# function foo_nginx {
# }

# https://ubuntu.com/tutorials/install-and-configure-wordpress#1-overview
    # Note that this sets the ownership to the user www-data, which is potentially insecure, such as when your server hosts multiple sites with different maintainers. You should investigate using a user per website in such scenarios and make the files readable and writable to only those users. This will require configuring PHP-FPM to launch a separate instance per site each running as the site’s user account. In such setup the wp-config.php should (read: if you do it differently you need a good reason) be readonly to the site owner and group and other permissions set to no-access (chmod 400). This is beyond the scope of this guide, however.
function install_apache_php_wordpress {
    if [[ ! -d /srv/www ]]; then
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}apache 2 php${RESET}${YELLOW} ####################${RESET}"
        $sa_update && $sa_install apache2 ghostscript libapache2-mod-php \
            mysql-server php php-bcmath php-curl php-imagick php-intl \
            php-json php-mbstring php-mysql php-xml php-zip
        sudo mkdir -p /srv/www
        sudo chown www-data: /srv/www
        echo -e "\n${YELLOW}########## Installing ${RED}${BOLD}WordPress${RESET}${YELLOW} ####################${RESET}"
        curl https://wordpress.org/latest.tar.gz | sudo -u www-data tar zx -C /srv/www
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}apache2 php WordPress${RESET}${YELLOW} are already installed ##########${RESET}"
    fi
}

function wordpress_config {
    if [[ ! -e /etc/apache2/sites-available/wordpress.conf ]]; then
        echo -e "\n${YELLOW}########## Enabling ${RED}${BOLD}wordpress${RESET}${YELLOW} site on ${RED}${BOLD}apache2${RESET}${YELLOW} ####################${RESET}"
        echo "<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
    <Directory /srv/www/wordpress/wp-content>
        Options FollowSymLinks
        Require all granted
    </Directory>
</VirtualHost>" | sudo tee /etc/apache2/sites-available/wordpress.conf
        sudo a2ensite wordpress             # Enable the site
        sudo a2enmod rewrite                # Enable URL rewriting
        sudo a2dissite 000-default          # Disable default "It Works" site
        # ...
        sudo service apache2 reload || sudo systemctl reload apache2
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}wordpress${RESET}${YELLOW} is already enabled on ${GREEN}${BOLD}apache2${RESET}${YELLOW} ##########${RESET}"
    fi
}

function wordpress_database {
    if [[ ! -e $wp_config_file ]]; then
        echo -e "\n${YELLOW}########## Enabling ${RED}${BOLD}wordpress${RESET}${YELLOW} database on ${RED}${BOLD}mysql${RESET}${YELLOW} ####################${RESET}"       
        echo -e "\n== Let's create the ${CYAN}new user${RESET} '${BOLD}wordpress${RESET}' for mysql-server =="
        local password_wordpress="0"; local password_wp_check="1"
        while [[ $password_wordpress != $password_wp_check ]]; do
            read -sp "Enter the password for the new user: " password_wordpress; echo ""
            read -sp "Re-enter the password: " password_wp_check; echo ""
            if [[ $password_wordpress != $password_wp_check ]]
                then echo -e "${RED}Error${RESET}: the passwords don't match. Please try again.\n"
                else echo -e "${GREEN}Success${RESET}! The password for '${BOLD}wordpress${RESET}' has been set.\n"
            fi
        done
        echo -e "CREATE DATABASE wordpress;\nCREATE USER wordpress@localhost IDENTIFIED BY '$password_wordpress';\nGRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON wordpress.* TO wordpress@localhost;" > $script_wordpress_sql
        echo -e "== Enter the mysql 'root' password (required atm to create a new user) =="
        mysql -u root -p -e "source $script_wordpress_sql"
        if [[ $? == 0 ]]
            then echo -e "${GREEN}Success!${RESET}" && rm $script_wordpress_sql
            else echo -e "${RED}Something went wrong... 🤸${RESET}"; return
        fi
        sudo service mysql start   

        echo -e "\n${YELLOW}########## Enabling ${RED}${BOLD}wordpress${RESET}${YELLOW} database at ${RED}${BOLD}$wp_config_file${RESET}${YELLOW} ####################${RESET}"       
        sudo -u www-data cp /srv/www/wordpress/wp-config-sample.php $wp_config_file
        sudo -u www-data sed -i 's/database_name_here/wordpress/' $wp_config_file
        sudo -u www-data sed -i 's/username_here/wordpress/' $wp_config_file
        sudo -u www-data sed -i "s/password_here/$password_wordpress/" $wp_config_file
        sudo -u www-data sed -i '/put your unique phrase here/d' $wp_config_file
        ##### TODO #############################################################
        echo -e "${RED}CHECK TODO${RESET}"
        ##### Then replace with the content of https://api.wordpress.org/secret-key/1.1/salt/.
        ##### (This address is a randomiser that returns completely random keys each time it is opened.)
        ##### This step is important to ensure that your site is not vulnerable to “known secrets” attacks.
    else
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}wordpress${RESET}${YELLOW} already exists on ${GREEN}${BOLD}mysql${RESET}${YELLOW} ##########${RESET}"
        echo -e "\n${YELLOW}########## ${GREEN}${BOLD}wordpress${RESET}${YELLOW} database is already enabled at ${GREEN}${BOLD}$wp_config_file${RESET}${YELLOW} ##########${RESET}"
    fi
}

function wordpress_dashboard {
        echo -e "\n${YELLOW}########## Time to ${RED}${BOLD}wordpress${RESET}${YELLOW} GUI ####################${RESET}"       
        echo -e "== On the browser, provide the ${BLUE}new info${RESET} along these lines =="
        echo -e "Site Title: Wordpressey
Username: whatever
Password: new_password
Your Email: whoami@test.com"
                # Note that the username and password you choose here are for WordPress, and do not provide access to any other part of your server - 
                # choose a username and password that are different to your MySQL (database) credentials, that we configured for WordPress’ use,
                # and different to your credentials for logging into your computer or server’s desktop or shell.
                # You can choose if you want to make your site indexed by search engines.
        echo -e "\n== Then, login with the ${BLUE}GUI credentials${RESET} just created ==\n"
        read -p "Ready? Press any key. " null
        xdg-open http://localhost &>/dev/null &                 # --new-window
        # xdg-open https://localhost/wp-login.php
        # xdg-open https://localhost/wp-admin
            # Posts --> Trash "Hello World!" --> Add New --> Edit --> Publish
        return
}

################################################################################
#                                   RUNTIME                                    # 
################################################################################

distro=$(grep "^ID=" /etc/os-release | awk -F '=' '{print $2}')
mysql_conf='/etc/mysql/mysql.conf.d/mysql.cnf'
script_sql='/tmp/mysql_newUser.sql'
script_wordpress_sql='/tmp/mysql_wordpress.sql'
wp_config_file='/srv/www/wordpress/wp-config.php'

start_time=$SECONDS
df_log_services='/tmp/autosetup-services.log'

RESET='\e[0m'
BOLD='\e[1m'
RED='\e[31m'
CYAN='\e[36m'
GREEN='\e[32m'
YELLOW='\e[33m'

sa_update="sudo apt-get update"

echo -e "\n${CYAN}### Logging ${RED}${BOLD}STARTING${RESET}${CYAN} disk usage to '${RED}${BOLD}$df_log_services${RESET}${CYAN}' ###${RESET}\n"
log_df_services

read -p "Do you want to skip all 'sudo apt-get install <package>' prompts? [Y/n] " opt
if [[ $opt == "Y" || $opt == "y" || $opt = "" ]]
    then sa_install="sudo apt-get install -y"
    else sa_install="sudo apt-get install"
fi

read -p "Do you want to set up *mysql*? [Y/n] " opt
if [[ $opt == "Y" || $opt == "y" || $opt = "" ]]; then
    setup_mysql='1'
fi

read -p "Do you want to set up *wordpress*? [Y/n] " opt
if [[ $opt == "Y" || $opt == "y" || $opt = "" ]]; then
    setup_wordpress='1'
fi

echo ""
system_update
case $setup_mysql in
    '1') install_mysql_wb_ubupop; config_mysql ;;
esac
case $setup_wordpress in
    '1') 
        install_apache_php_wordpress &&
        wordpress_config &&
        wordpress_database &&
        wordpress_dashboard
    ;;
esac

echo -e "\n${CYAN}### Logging ${RED}${BOLD}FINAL${RESET}${CYAN} disk usage to '${RED}${BOLD}$df_log_services${RESET}${CYAN}' ###${RESET}"
log_df_services

end_time=$((SECONDS - start_time))
secs_to_mins $end_time
echo -e "\n${GREEN}# Script execution time: ${RED}${BOLD}$end_time${RESET}${GREEN} seconds, (${RED}${BOLD}$end_time_minutes${RESET}${GREEN} minutes). #${RESET}\n"


# ==========x==========

#   verify the /etc/mysql files...

# case $setup_mysql in
#     '1')
#     case $distro in
#         "ubuntu" | "pop") install_mysql_wb_ubupop; config_mysql ;;
#     esac
# esac
# case $setup_wordpress in
#     '1')
#     case $distro in
#         # "debian") install_mysql_wb_deb ;;
#         "ubuntu" | "pop") install_mysql_wb_ubupop ;;
#     esac
#     config_mysql
# fi
