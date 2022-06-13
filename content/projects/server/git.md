---
title: "Git"
date: "2022-06-13T08:55:26+02:00"
summary: "Persönlicher Gitea Server"
ShowToc: false
TocOpen: false
comments: false
draft: false
weight: 2
---

## Welche Komponenten nutzt der Server

Mein privater Git Server nutzt

+ Gitea,
+ Postresql und
+ Nginx.

## Warum Gitea?

Manche Menschen wundern sich, warum ich nicht einfach Github oder Gitlab benutze. Warum hoste ich meinen eigenen Server, welcher extra Strom, Leistung und Geld kostet? Ehrlich gesagt, wollte ich probieren ob es möglich ist. Um einen Ort zu schaffen auf, wo ich Software hosten kann, welche ich geschrieben habe und brauche. Natürlich sollten die meisten Menschen diese Services nutzen.

## Wie setzt man Gitea auf?

Gitea ist eine sehr einfach zu hostende Applikation. Die einzigen Bedingungen, die es hat, sind ein Reverse Proxy, eine Datenbank und die Applikation an sich. Laut der [Dokumentation](https://docs.gitea.io/en-us/database-prep/) können mehrere Datenbank als Lösungen genommen werden. Die Qual der Wahl. Es kann MySQL, PostgreSQL, SQLite und MSSQL genutzt werden. Ich habe mich für PostgreSQL entschieden.

Als Reverse Proxy kann hier natürlich auch verschiedenes genutzt werden. Für mich ist auch hier die Entscheidung leicht gefallen. Nginx. Warum denn nicht?

+ Link zum Server --> [Online](https://git.mjindra.eu)
