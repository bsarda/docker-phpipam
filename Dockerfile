# written by Benoit Sarda
# ejbca container. uses bsarda/jboss by copy/paste.
#
#   bsarda <b.sarda@free.fr>
#
# FROM centos:centos7.2.1511
FROM centos:centos7.2.1511

MAINTAINER Benoit Sarda <b.sarda@free.fr>

# expose
EXPOSE 80

# declare vars
ENV TIMEZONE="Europe/Paris" \
		DB_SERVER="172.12.31.2" \
		DB_PORT=3306 \
		DB_NAME="phpipam"

# add files
ADD [	"init.sh", \
	"stop.sh", \
	"/opt/"]

RUN echo "LC_ALL=en_US.utf-8" > /etc/environment && echo "LANG=en_US.utf-8" >> /etc/environment
# install
RUN	yum install -y httpd php php-cli php-gd php-common php-ldap php-pdo php-pear php-snmp php-xml php-mysql php-mbstring git net-tools wget lynx
# replace content in httpd.conf
RUN sed -i '/^ServerName.*/d' /etc/httpd/conf/httpd.conf && echo "ServerName locahost:80" >> /etc/httpd/conf/httpd.conf
RUN sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/c <Directory "\/var\/www\/html">\n    Options Indexes FollowSymLinks\n    AllowOverride all\n    Require all granted\n<\/Directory>' /etc/httpd/conf/httpd.conf
# setup php.ini
RUN echo "date.timezone=$TIMEZONE" >> /etc/php.ini
# change rights
RUN chmod 750 /opt/init.sh && chmod 750 /opt/stop.sh

#WORKDIR /var/www/html/
RUN cd /var/www/html/ && git clone https://github.com/phpipam/phpipam.git . && git checkout 1.2 && cp config.dist.php config.php

# ownership and selinux of html dir
RUN chown apache:apache -R /var/www/html/
RUN cd /var/www/html/ && find . -type f -exec chmod 0644 {} \; && find . -type d -exec chmod 0755 {} \;
RUN chcon -t httpd_sys_content_t /var/www/html/ -R
RUN chcon -t httpd_sys_rw_content_t /var/www/html/app/admin/import-export/upload/ -R && \
		chcon -t httpd_sys_rw_content_t /var/www/html/app/subnets/import-subnet/upload/ -R && \
		chcon -t httpd_sys_rw_content_t /var/www/html/css/1.2/images/ -R

# TO DO ON DB
#
# CREATE DATABASE phpipam CHARACTER SET utf8 COLLATE utf8_bin;
# CREATE USER 'phpipam'@'%' IDENTIFIED BY 'phoeniX1';
# GRANT ALL PRIVILEGES ON phpipam.* TO 'phpipam'@'%' WITH GRANT OPTION;
# FLUSH PRIVILEGES;
#
# ##

#RUN chkconfig httpd on && service httpd start
# put scripts files and change database.ini content

CMD ["/opt/init.sh"]
