#!/bin/bash

#INSTALLDIR=/usr/local/bin
#LOGDIR=/var/log/netcheck
INSTALLDIR=$HOME/.local/bin
LOGDIR=$HOME/.netcheck

if [ "${1}" == "--no-service" ]; then
  SERVICE=
  echo "Not installing service by-request"
elif [ "$(whoami)" == "root" ]; then
  SERVICE=1
  echo "Running as sudo/root, installing service"
else
  SERVICE=
  echo "Not running as sudo/root, can not install service"
fi

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


if [ $SERVICE ]; then

  [ "$(whoami)" == "root" ] || echo "Service installation will fail without sudo."

  # service files
  cp -rv etc/default /
  cp -rv etc/init.d /

  # quote paths for sed'sake
  INSTALLDIRQUOTED=$(printf '%s' "$INSTALLDIR" | sed 's/[#\]/\\\0/g')
  LOGDIRQUOTED=$(printf '%s' "$LOGDIR" | sed 's/[#\]/\\\0/g')

  sed -e "s#INSTALLDIR#${INSTALLDIRQUOTED}#g" -e "s#LOGDIR#${LOGDIRQUOTED}#g" etc/sudoers.d/netcheck | tee /etc/sudoers.d/netcheck > /dev/null
  sed -e "s#INSTALLDIR#${INSTALLDIRQUOTED}#g" -e "s#LOGDIR#${LOGDIRQUOTED}#g" etc/default/netcheck | tee /etc/default/netcheck > /dev/null

  # creating python link if it's missing
  [ $(which python) ] || ln -s $(which python3) /usr/bin/python

  # Verifying service installed correctly
  service netcheck status

  echo add \"service netcheck start\" to /etc/wsl.conf
fi

# modify script default log dir
LOGDIRQUOTED=$(printf '%s' "$LOGDIR" | sed 's/[#\]/\\\0/g')
sed -e "s#LOGDIR#${LOGDIRQUOTED}#g" netcheck.sh | tee $INSTALLDIR/netcheck.sh > /dev/null
sed -e "s#LOGDIR#${LOGDIRQUOTED}#g" internet_status_chart.sh | tee $INSTALLDIR/internet_status_chart.sh > /dev/null
# hopefully that's not a race condition?
