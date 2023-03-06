#!/bin/bash

mkdir -p /run/sshd
exec /usr/sbin/sshd -o StrictModes=no -D
