#!/bin/sh

HACK_INI=/tmp/hack.ini
/usr/bin/awk -F "=" '
BEGIN {
  printf("*/15 * * * * /usr/sbin/logrotate /etc/logrotate.conf\n");
  printf("0 * * * * /scripts/remove_old.sh\n");
  printf("0 * * * * /scripts/memory_check.sh\n");
  printf("* * * * * /scripts/health_check.sh\n");
  printf("* * * * * /scripts/lighttpd.sh watchdog >> /media/mmc/atomhack.log\n");
  printf("* * * * * /scripts/rtspserver.sh watchdog >> /media/mmc/atomhack.log\n");
}

/REBOOT_SCHEDULE *=/ {
  if($2 == "") next;
  gsub(/:/,",", $2);
  printf("%s /scripts/reboot.sh\n", $2);
}
' $HACK_INI | crontab -
