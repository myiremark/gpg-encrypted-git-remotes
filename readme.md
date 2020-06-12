# gpg-encrypted-git-remotes

git-remote-gcrypt allows seamless encryption of remote git repositories.  This repo demonstrates how to store code remotely, encrypted, and still collaborate using git.

# HIGHLIGHTS

- GPG Key Creation
- Encrypted centralized git sharing
- Assumes an untrusted hosting environment

# KEYWORDS

- [gnupg](https://gnupg.org/)
- [pgp](https://gnupg.org/)
- [git](https://git-scm.com/)
- [ssh](https://www.ssh.com/ssh/)
- [git-remote-gcrypt](https://github.com/spwhitton/git-remote-gcrypt)

## Instructions

The contents of [https://github.com/myiremark/gpg-encrypted-git-remotes-encrypted.git](https://github.com/myiremark/gpg-encrypted-git-remotes-encrypted.git) are encrypted using the private key in this repo.  

This can be verified by building the receiver container, importing the gpg key and pulling using the enclosed receiver.Dockerfile.

The output hash for the last commit should be the same using the commands below.

```
git clone git@github.com:myiremark/gpg-encrypted-git-remotes.git && cd gpg-encrypted-git-remotes
```

# sender

#### notice the --no-cache below! we're using git in the docker files.

## build and run the sender container

```
docker build -t myiremark/gpg_encrypted_repo_sender:latest -f sender.Dockerfile .  --no-cache

docker run -dt --name=gpg_encrypted_repo_sender myiremark/gpg_encrypted_repo_sender:latest
```

## get private exported key for copying into receiver container

```
PRIVATE_KEY_CONTENTS=$(docker exec -it gpg_encrypted_repo_sender cat /root/privatekey.asc) && echo "$PRIVATE_KEY_CONTENTS" > sender.privatekey.asc

docker exec -it gpg_encrypted_repo_sender cat /root/.ssh/id_ecdsa.pub > sender_pub_key.pub
```

### make sure the public key above is in your version control ssh authorized keys

```
docker exec -it gpg_encrypted_repo_sender /bin/bash -c "cd /root/gpg-encrypted-git-remotes && git remote -v"

docker exec -it gpg_encrypted_repo_sender /bin/bash -c "cd /root/gpg-encrypted-git-remotes && git pull origin master"
```

### make your modifications then push to a new repo
```
docker exec -it gpg_encrypted_repo_sender /bin/bash -c "cd /root/gpg-encrypted-git-remotes && git push cryptremote master"
```

## make note of the current commit hash for checking later
```
docker exec -it gpg_encrypted_repo_sender /bin/bash -c "cd /root/gpg-encrypted-git-remotes && git checkout origin/master && git rev-parse HEAD"
```
## make changes to repo and push 

```
docker exec -it gpg_encrypted_repo_sender /bin/bash -c "cd /root/gpg-encrypted-git-remotes && git push cryptremote master"
```

# Receiver

```
docker build -t myiremark/gpg_encrypted_repo_receiver:latest -f receiver.Dockerfile .  --no-cache

docker run --name=gpg_encrypted_repo_receiver -dt myiremark/gpg_encrypted_repo_receiver:latest
```

## see the unencrypted repo and its commit hash
```
docker exec -it gpg_encrypted_repo_receiver /bin/bash -c "cd /root/unencrypted && git pull cryptremote master && git checkout master && git rev-parse HEAD"
```