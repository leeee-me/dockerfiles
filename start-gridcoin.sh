#!/bin/bash

rm -rf /home/$GRCUSER/.GridcoinResearch/.lock
su - $GRCUSER -c "/usr/bin/gridcoinresearchd -daemon"
sleep 10s
tail -f /home/$GRCUSER/.GridcoinResearch/debug.log

