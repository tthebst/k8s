#!/bin/sh

/usr/bin/curl -Is https:/www.stockbuilder.tk | grep 200 || echo "The site is down" | /usr/bin/mail -s "Site is down(stockbuilder.tk)" gretler.tim@gmail.com < /dev/null
/usr/bin/curl -Is https:/www.timgretler.ch | grep 200 || echo "The site is down" | /usr/bin/mail  -s "Site is down(timgretler.ch)" gretler.tim@gmail.com < /dev/null
/usr/bin/curl -Is https://www.speechgroup.ch  | grep 200 || echo "The site is down" | /usr/bin/mail  -s "Site is down(speechgroup.ch)" gretler.tim@gmail.com < /dev/null
/usr/bin/curl -Is https:/www.stockbuilder123.ch| grep 200 || echo "The site is down" | /usr/bin/mail  -s "Site is down(stockbuilder.ch)" gretler.tim@gmail.com < /dev/null
