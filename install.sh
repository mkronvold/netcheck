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
cp -rv log/* $LOGDIR/

# service files
sudo cp -rv etc/default /
sudo cp -rv etc/init.d /

# quote paths for sed'sake
INSTALLDIRQUOTED=$(printf '%s' "$INSTALLDIR" | sed 's/[#\]/\\\0/g')
LOGDIRQUOTED=$(printf '%s' "$LOGDIR" | sed 's/[#\]/\\\0/g')

cat etc/sudoers.d/netcheck | sed -e "s#INSTALLDIR#${INSTALLDIRQUOTED}#g" | sed -e "s#LOGDIR#${LOGDIRQUOTED}#g" | sudo tee /etc/sudoers.d/netcheck > /dev/null
cat etc/default/netcheck | sed -e "s#INSTALLDIR#${INSTALLDIRQUOTED}#g" | sed -e "s#LOGDIR#${LOGDIRQUOTED}#g" | sudo tee /etc/default/netcheck > /dev/null

# creating python link if it's missing
[ $(which python) ] || sudo ln -s $(which python3) /usr/bin/python

# Verifying service installed correctly
sudo service netcheck status

echo add \"service netcheck start\" to /etc/wsl.conf
