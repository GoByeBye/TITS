#!/bin/bash
set -e
cp /bd_build/clean_install /sbin/clean_install
set -x

# Prevent initramfs updates from trying to run grub and lilo.

export INITRD=no
mkdir -p /etc/container_environment
echo -n no > /etc/container_environment/INITRD

# Enable Universe, Multiverse and security updates for main
sed -i 's/^#\s*\(deb.*main restricted\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*universe\)$/\1/g' /etc/apt/sources.list
sed -i 's/^#\s*\(deb.*multiverse\)$/\1/g' /etc/apt/sources.list


# Update package list since old cache is invalidated due to mirror change
apt-get update -y

# Fix issues with APT packages
# https://github.com/moby/moby/issues/1024
dpkg-divert --local --rename --add /sbin/initctl
ln -sf /bin/true /sbin/initctl

clean_install  apt-utils

# Enable HTTPS for APT
clean_install apt-transport-https ca-certificates

clean_install software-properties-common

# Tools needed for functionality 
clean_install curl git nano

# Upgrade all packages.
apt-get update -y && apt-get upgrade -y --no-install-recommends -o Dpkg::Options::="--force-confold"

