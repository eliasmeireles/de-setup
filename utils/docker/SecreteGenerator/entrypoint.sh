#!/bin/bash

if [ ! -f /root/.ssh/id_ed25519 ]; then

    ssh-keygen -t ed25519 -f /root/.ssh/id_ed25519 -q -N "" -C "$USER_EMAIL"

    openssl genpkey -algorithm RSA -out /root/.ssh/"private.key"
    openssl rsa -pubout -in /root/.ssh/"private.key" -out /root/.ssh/"public.key"

    sync
fi

tail -f /dev/null
