#!/bin/bash
touch /opt/letitrun

echo "Starting the container"
# stop apache, in case of
/usr/sbin/httpd -k stop
# get and set timezone
wcphptimezone=$(grep ^date.timezone -i /etc/php.ini | wc -l)
if [ $wcphptimezone -eq 0 ] ; then echo "date.timezone=$TIMEZONE" >> /etc/php.ini ; else sed -i "s@^date.timezone=.*@date.timezone=$TIMEZONE@" /etc/php.ini ; fi
# set php database source
#sed -i "s@\['host'\]\s*=.*@\['host'\] = \"$DB_SERVER\";@gi" /var/www/html/config.php
sed -i "s@\['host'\]\s*=.*@\['host'\] = \"172.17.0.2\";@gi" /var/www/html/config.php
sed -i "s@\['name'\]\s*=.*@\['name'\] = \"$DB_NAME\";@gi" /var/www/html/config.php
sed -i "s@\['port'\]\s*=.*@\['port'\] = $DB_PORT;@gi" /var/www/html/config.php

# database user
#sed -i "s@\['user'\]\s*=.*@\['user'\] = \"$DB_USER\";@gi" /var/www/html/config.php
# database password - specific char escape
#DB_PASSWORD=$(echo "$DB_PASSWORD" | sed 's/|/<PIPEFORTEMPREPLACEMENT>/g')
#sed -i "s|db\['pass'\]\s*=.*|db\['pass'\] = \"$DB_PASSWORD\";|gi" /var/www/html/config.php
#sed -i "s@<PIPEFORTEMPREPLACEMENT>@|@gi" /var/www/html/config.php

#start apache
/usr/sbin/httpd -k start

# wait in an infinite loop for keeping alive pid1
trap '/bin/sh -c "/opt/stop.sh"' SIGTERM
while [ -f /opt/letitrun ]; do sleep 1; done
exit 0;
