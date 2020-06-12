#!/bin/bash

export GNUPGHOME="/root/.gnupg";

mkdir -p $GNUPGHOME;

gpg --batch --generate-key /root/gpg_key_params;

gpg --list-secret-keys;

chmod -R 400 $GNUPGHOME;

ID_KEY=$(gpg -k | grep "uid" -m 1 -B 1 | grep -v "uid" | sed -e 's/^[[:space:]]*//') && gpg --export-secret-keys --armor $ID_KEY > /root/privatekey.asc;