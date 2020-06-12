FROM ubuntu:18.04

MAINTAINER "Mark Graves <mark@myire.com>"

RUN apt-get update -y && apt-get install -y gpg git git-remote-gcrypt

# Copy and import gpg key

COPY sender.privatekey.asc /root/sender.privatekey.asc

RUN gpg --import /root/sender.privatekey.asc

RUN cd /root/ && gpg --homedir /root/.gnupg --no-tty --command-fd 0 --expert --edit-key sender@domain.com trust

RUN cd /root/ && git clone https://github.com/myiremark/gpg-encrypted-git-remotes-encrypted.git

RUN mkdir /root/unencrypted

RUN cd /root/unencrypted && git init .

RUN cd /root/unencrypted && git remote add cryptremote gcrypt::/root/gpg-encrypted-git-remotes-encrypted 

RUN cd /root/unencrypted && git pull cryptremote master && git checkout master

RUN ls /root/unencrypted