
uses netcat - requirement of libvirt over ssh

requires arpwatch to be installed
watch log files

vi /etc/rsyslog.d/30-arpwatch.conf

#:msg, contains, "arpwatch:" -/var/log/arpwatch.log
#& ~
if $programname =='arpwatch' then /var/log/arpwatch.log
& ~
