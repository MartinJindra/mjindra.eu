---
title: "Git"
date: "2022-06-22"
author: "Martin Jindra"
aliases: []
tags: []
summary: "Personal Gitea server"
ShowToc: true
TocOpen: true
comments: false
draft: false
weight: 2
---

## Why Gitea?

Some people wonder why I don't just use Github or Gitlab. Why do I host my own server, which costs extra power, performance and money? Honestly, I wanted to try if it was possible. To create a place on where I can host software which I have written and need. Of course, most people should use these services as they simply offer more convenience.

## How to set up Gitea?

### Basics

Gitea is a very simple application to host. The only conditions it has are a reverse proxy, a DBMS (Database Management System) and the application itself. According to the [documentation](https://docs.gitea.io/en-us/database-prep/), you can choose between multiple DBMSs. I know the agony of choice :wink:. MySQL, PostgreSQL, SQLite and MSSQL can be used. For my server I decided to use PostgreSQL.

For the reverse proxy various choices can also be used. The decision for me was also here really easy. Nginx. Why not? It is lighter, faster and easier to configure than Apache HTTP Server.

### Requirements

Debian 11 is used for this tutorial. The setup requires the following prerequisites.

- [x] *root* privileges on the server
- [x] Port 80 (HTTP) and port 443 (HTTPS) are freely accessible
- [x] Public IP address
- [x] ev. a domain pointing to the IP address.

Important information in this manual:

1. Domain: `git.domain.com`
2. Mail: `user@domain.com`
3. User: `user`
4. Password: `password`

### First steps

To connect to the server.

```
ssh user@git.domain.com
```

Before doing anything else, the system should have the latest security and feature updates.

```
sudo apt update && sudo apt upgrade
```

In some cases you should reboot if e.g. the kernel got an update and then connect to the server again.

```
sudo systemctl reboot
```

Reconnect again.

```
ssh user@git.domain.com
```

----

### DBMS

We now install the necessary DBMS, which Gitea needs to work. As mentioned above, different types of a DB can be used here. I decide to use PostgreSQL, because I have more positive experience than, for example, MySQL.

Since we are working on a Linux machine, we can simply use a package manager, like apt, to install our software.

```
sudo apt install postgresql-13
```

apt installs the management system for you and makes sure that it restarts automatically after a reboot. Debian 11 uses the older version 13 of PostgreSQL.

We start with the configuration of the DBMS to provide a bit more security. The changes take place in the file `postgresql.conf` in the path `/etc/postgresql/13/main/`. So use your favorite terminal editor like _nano_ or _vim_. The option `password_encryption` should get the value `scram-sha-256` to use a secure hashing method.

```
password_encryption = scram-sha-256
```

Then restart the DBMS to apply the changes.

```
sudo systemctl restart postgresql
```

Now we can connect and set up a user, which will be used by Gitea to store the data. To do this, we need to run the `psql` command as the _postgres_ user.

```
su -c 'psql' - postgres
```

We are now in the PostgreSQL shell and a little knowledge of SQL can never hurt. So we use these skills to create the new user named _gitea_ with the database _giteadb_. You can also use another name, but it must be inserted later instead of _gitea_ or _giteadb_.

PLEASE USE A SECURE PASSWORD.

```
CREATE ROLE gitea WITH LOGIN PASSWORD 'password123';
CREATE DATABASE giteadb WITH OWNER gitea TEMPLATE template0 ENCODING UTF8;
exit
```

To give the user access to the local DB, add this line in the file `pg_hba.conf` in the path `/etc/postgresql/13/main/`.

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   giteadb         gitea                                   scram-sha-256
```

And restart the DBMS again.

```
sudo systemctl restart postgresql
```

To test the DB, run.

```
su postgres
psql -U gitea -d giteadb
```

[1]

----

### Nginx

Now it depends on how we want to use the server. You can use it only for Gitea or host other services as well. For this I would recommend reading more into the [Nginx docs](https://nginx.org/en/docs/). I will set up the server to run only Gitea on it.

It is very useful if the git server gets a subdomain like `git`. That way we don't have to buy a new domain every time we want to do something new.

Don`t worry the DBMS was the hardest part :wink:.

Just install Nginx.

```
sudo apt install nginx
```

Create the file `/etc/nginx/sites-available/gitea` and add the content. Change the value `git.domain.com` with your own domain.

```
server {
    listen 80;
    listen [::]:80;
    server_name git.domain.com;
    return 301 https://$server_name$request_uri;
    access_log /var/log/nginx/gitea-proxy_access.log;
    error_log /var/log/nginx/gitea-proxy_error.log;
}
server {
    listen 443 ssl;
    listen [::]:443 ssl;
    server_name git.domain.com;
    ssl on;
    ssl_certificate /etc/letsencrypt/live/git.domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/git.domain.com/privkey.pem;
    location / {
        proxy_pass http://unix:/var/run/gitea/gitea.sock;
    }
    access_log /var/log/nginx/gitea-proxy_access.log;
    error_log /var/log/nginx/gitea-proxy_error.log;
}
```

We are not quite finished yet, because we are still missing an SSL certificate.

Please don't forget that if you want to have a certificate, you agree to their TOS.

Install `certbot` and get a certificate.

```
sudo apt install certbot python3-certbot-nginx
sudo certbot certonly -d git.domain.com -m user@domain.com --agree-tos --standalone
```

And finally restart Nginx.

```
sudo systemctl restart nginx
```

### Gitea

Check on [https://dl.gitea.io/gitea/](https://dl.gitea.io/gitea/) which is the latest version of Gitea and copy the link.

Download Gitea with `wget`.

```
wget -O gitea https://dl.gitea.io/gitea/1.16.9/gitea-1.16.9-linux-amd64
```

Install `git` in any case.

```
sudo apt install git
```

Add a new user.

```
sudo adduser \
   --system \
   --shell /bin/bash \
   --gecos 'Git Version Control' \
   --group \
   --disabled-password \
   --home /home/git \
   git
```

Set the permissions.

```
sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/
sudo mkdir /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea
```

Visit the Gitea page and set up the information correctly.

Gitea changed the permissions from the `/etc/gitea` directory during the setup, so you have to set them again.

```
sudo chmod 750 /etc/gitea
sudo chmod 640 /etc/gitea/app.ini
```

[2]

And if everything worked, your own Git server should work :+1:. Additional features can also be enabled, just visit the [documentation](https://docs.gitea.io/en-us/) of Gitea. But if something didn't work, a search on the internet or forums can't hurt.

----

## Sources

1. Database Preparation - Docs --> [Online](https://docs.gitea.io/en-us/database-prep/#postgresql)
2. Installation from binary --> [Online](https://docs.gitea.io/en-us/install-from-binary/)
3. Link to server [online](https://git.mjindra.eu)
