#!/bin/bash

yum update -y
yum install -y socat

yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install -y mysql-community-client

timedatectl set-timezone Asia/Tokyo
localectl set-locale LANG=ja_JP.utf8
hostnamectl set-hostname ${HOST_NAME}

cat <<EOF > /root/.bashrc
# .bashrc

# User specific aliases and functions
export PS1='\[\e[1;34m\]\D{%y/%m/%d %H:%M:%S}\e[0m \[\e[1;32m\]\u@\h\e[0m \[\e[1;33m\]\w\e[0m\n\[\e[1;30m\]>\[\e[0m\] '
PROMPT_COMMAND="echo"
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lld='ls -ld'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias vi='vim'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
EOF

sudo reboot
