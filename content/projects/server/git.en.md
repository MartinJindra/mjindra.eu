---
title: "Git"
date: "2022-06-13T08:55:26+02:00"
summary: "Personal Gitea server"
ShowToc: false
TocOpen: false
comments: true
draft: false
weight: 2
---

## What does the server use

My private git server uses

+ Gitea,
+ Postresql and
+ Nginx.

## Why use Gitea?

Some people may wonder why not just use Github or Gitlab. Why host your own git server that uses extra power and costs money? Honestly I just wanted to try if it is possible. To create a place where I can host software that I write and need. Of course most people should use these services.

## How to set up Gitea?

Gitea is a very simple application to host. The only conditions it has are a reverse proxy, a database and the application itself. According to the documentation, multiple database can be used. The agony of choice. MySQL, PostgreSQL, SQLite and MSSQL will do the job. I decided to use PostgreSQL.

You also have a lot of choices with the reverse proxy. For me, the decision was also easy here. Nginx. Why not?

+ Link to server [online](https://git.mjindra.eu)
