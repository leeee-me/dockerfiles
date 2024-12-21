#!/bin/bash

rm -rf /home/me/.GridcoinResearch/.lock
su - me -c "/usr/bin/gridcoinresearchd -daemon"
sleep 10s
tail -f /home/me/.GridcoinResearch/debug.log

