#!/bin/bash
set -xe

apt-get clean
find /bd_build/ -not \( -name 'bd_build' -or -name 'buildconfig' -or -name 'cleanup.sh' \) -delete
rm -rf /tmp/* /var/tmp/*
rm -rf /var/lib/apt/lists/*
rm -f /etc/ssh/ssh_host_*
rm -rf /bd_build