#!/bin/bash
echo "WE'RE ABOUT TO STOP RIGHT NOW !"
/usr/sbin/httpd -k stop
echo "Everything is properly stopped, we can exit"
# everything is properly stopped, we can exit
rm -f /opt/letitrun
