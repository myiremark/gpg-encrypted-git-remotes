FROM ubuntu:18.04

MAINTAINER "Mark Graves <mark@myire.com>"

RUN apt-get update -y && apt-get install -y gpg git git-remote-gcrypt

# Create a GPG key non interactively, in batch

COPY key_params_sender /root/gpg_key_params

COPY generate-key.sh /root/generate-key.sh

RUN /root/generate-key.sh

# generate an ssh key to push to remote repo

RUN ssh-keygen -t ecdsa -f /root/.ssh/id_ecdsa -q -P "" 0>&-

RUN mkdir /root/gpg-encrypted-git-remotes

RUN cd /root/gpg-encrypted-git-remotes && git init .

# add both encrypted and unencrypted urls for demo

RUN cd /root/gpg-encrypted-git-remotes && git remote add origin https://github.com/myiremark/gpg-encrypted-git-remotes.git

RUN cd /root/gpg-encrypted-git-remotes && git remote add cryptremote gcrypt::git@github.com:myiremark/gpg-encrypted-git-remotes-encrypted.git