#!/bin/bash

#INSTALLDIR=/usr/local/bin
#LOGDIR=/var/log/netcheck
INSTALLDIR=$HOME/.local/bin
LOGDIR=$HOME/.netcheck

# install
mkdir -p $INSTALLDIR
cp netcheck.sh $INSTALLDIR
cp internet_status_chart.sh $INSTALLDIR

# let netcheck.sh take care of the latest speedtest-cli
#cp speedtest-cli.py $INSTALLDIR

# are these needed for web service?
#cp -rv *.png $INSTALLDIR


# installing log directory
mkdir -p $LOGDIR
cp -rv log $LOGDIR

# service files
cp -rv etc /
cat etc/default/netcheck | sed -e 's/INSTALLDIR/${INSTALLDIR}/g' | sed -e 's/LOGDIR/${LOGDIR}/g' > /etc/default/netcheck
cat etc/sudoers.d/netcheck | sed -e 's/INSTALLDIR/${INSTALLDIR}/g' | sed -e 's/LOGDIR/${LOGDIR}/g' > /etc/sudoers.d/netcheck

# creating python link if it's missing
[ $(which python) ] || ln -s $(which python3) /usr/bin/python

# Verifying service installed correctly
service netcheck status

echo add \"service netcheck start\" to /etc/wsl.conf
