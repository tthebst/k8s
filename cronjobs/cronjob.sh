#!/bin/sh

#/usr/bin/curl -Is https:/www.stockbuilder.tk | grep 200 || printf "To: gretler.tim@gmail.com\nFrom: RaspberryPi3\nSubject: Site is down(stockbuilder.tk)\n\nThere is somthing wrong. Let's go!\n" | ssmtp -t 
/usr/bin/curl -Is https:/www.timgretler.ch | grep 200 || (printf "To: gretler.tim@gmail.com\nFrom: RaspberryPi3\nSubject: Site is down(timgretler.ch)\n\nThere is somthing wrong. Let's go!\n" | ssmtp -t) 
/usr/bin/curl -Is https://www.speechgroup.ch  | grep 200 || (printf "To: gretler.tim@gmail.com\nFrom: RaspberryPi3\nSubject: Site is down(www.speechgroup.ch )\n\nThere is somthing wrong. Let's go!\n" | ssmtp -t) 
/usr/bin/curl -Is https:/www.stockbuilder123.ch| grep 200 || (printf "To: gretler.tim@gmail.com\nFrom: RaspberryPi3\nSubject: Site is down(stockbuilder.ch)\n\nThere is somthing wrong. Let's go!\n" | ssmtp -t)

