---
title: "Git"
date: "2022-06-21T08:55:26+02:00"
author: "Martin Jindra"
aliases: ["/git"]
tags: []
summary: "Persönlicher Gitea Server"
ShowToc: true
TocOpen: true
comments: false
draft: false
weight: 2
---

## Warum Gitea?

Manche Menschen wundern sich, warum ich nicht einfach Github oder Gitlab benutze. Warum hoste ich meinen eigenen Server, welcher extra Strom, Leistung und Geld kostet? Ehrlich gesagt, wollte ich probieren ob es möglich ist. Um einen Ort zu schaffen auf, wo ich Software hosten kann, welche ich geschrieben habe und brauche. Natürlich sollten die meisten Menschen diese Services nutzen, da diese einfach mehr Bequemlichkeit anbieten.

## Wie setzt man Gitea auf?

### Grundlagen

Gitea ist eine sehr einfach zu hostende Applikation. Die einzigen Bedingungen, die es hat, sind ein Reverse Proxy, eine DBMS (Database Management System) und die Applikation an sich. Laut der [Dokumentation](https://docs.gitea.io/en-us/database-prep/) können mehrere DBMS als Lösungen genommen werden. Ich weiß die Qual der Wahl :wink:. Es kann MySQL, PostgreSQL, SQLite und MSSQL genutzt werden. Für meinen Server habe ich mich für PostgreSQL entschieden.

Als Reverse Proxy kann hier natürlich auch verschiedenes genutzt werden. Für mich ist auch hier die Entscheidung leicht gefallen. Nginx. Warum denn nicht? Es ist leichter, schneller und einfacher zu konfigurieren als Apache HTTP Server.

### Voraussetzungen

Für diese Anleitung wird Debian 11 verwendet. Die Einrichtung benötigt folgende Voraussetzungen.

- [x] *root*-Rechte am Server
- [x] Port 80 (HTTP) und Port 443 (HTTPS) sind frei zugänglich
- [x] Öffentlich IP-Adresse
- [x] ev. eine Domain, welche auf die IP-Adresse zeigt.

Wichtige Informationen in dieser Anleitung:

1. Domain: `git.domain.com`
2. Mail: `user@domain.com`
3. User: `user`
4. Passwort: `password`

### Erste Schritte

Um eine Verbindung zum Server aufzubauen.

```
ssh user@git.domain.com
```

Bevor irgendwas anderes gemacht wird, soll das System die aktuellsten Sicherheit- und Featureupdates haben.

```
sudo apt update && sudo apt upgrade
```

In manchen Fällen sollte man neu starten, falls z.B. der Kernel ein Update bekommen hat und sich dann wieder zum Server zu verbinden.

```
sudo systemctl reboot
```

Wieder eine Verbindung aufbauen.

```
ssh user@git.domain.com
```

----

### DBMS

Wir installieren jetzt die notwendige DBMS, welche Gitea zum Arbeiten braucht. Wie oben schon erwähnt, können hier verschiedene Arten einer DB genutzt werden. Ich entscheide mich für PostgreSQL, da ich mehr positive Erfahrung habe als z.B. MySQL.

Da wir auf einer Linux Maschine arbeiten, können wir einfach einen Paketmanager, wie apt nutzen, um unsere Software zu installieren.

```
sudo apt install postgresql-13
```

apt installiert einem das Managementsystem und sorgt dafür, dass sie nach einem Neustart automatisch wieder startet. Debian 11 nutzt die ältere Version 13 von PostgreSQL.

Wir starten mit der Konfiguration des DBMS, um ein bisschen mehr Sicherheit zu gewährleisten. Die Änderungen finden in der Datei `postgresql.conf` im Pfad `/etc/postgresql/13/main/` statt. Nimm also deinen liebsten Terminaleditor wie _nano_ oder _vim_ zur Hand. Die Option `password_encryption` sollte den Wert `scram-sha-256` bekommen, um eine sichere Hashing-Methode zu nutzen.

```
password_encryption = scram-sha-256
```

Dann die DBMS neu starten, um die Änderungen anzuwenden.

```
sudo systemctl restart postgresql
```

Jetzt können wir uns eine Verbindung aufbauen und einen User einrichten, welcher von Gitea zur Speicherung der Daten genutzt wird. Dafür müssen wir als _postgres_ User den Befehl `psql` ausführen.

```
su -c 'psql' - postgres
```

Wir sind nun in der PostgreSQL Shell und ein bisschen Wissen von SQL kann niemals schaden. Also verwenden wir diese Skills,um den neuen Benutzer namens _gitea_ mit der Datenbank _giteadb_ zu erstellen. Man kann auch einen anderen Namen nutzen, dieser muss dann aber später anstelle von _gitea_ oder _giteadb_ eingefügt werden.

BITTE EIN SICHERES PASSWORT NUTZEN.

```
CREATE ROLE gitea WITH LOGIN PASSWORD 'password123';
CREATE DATABASE giteadb WITH OWNER gitea TEMPLATE template0 ENCODING UTF8;
exit
```

Um dem Benutzer Zugriff auf die lokale DB zu geben, füge in der Datei `pg_hba.conf` im Pfad `/etc/postgresql/13/main/` diese Zeile hinzu.

```
# TYPE  DATABASE        USER            ADDRESS                 METHOD
local   giteadb         gitea                                   scram-sha-256
```

Und das DBMS wieder neu starten.

```
sudo systemctl restart postgresql
```

Um die DB zu testen, führ aus.

```
su postgres
psql -U gitea -d giteadb
```

[1]

----

### Nginx

Jetzt kommt es drauf an, wie wir den Server nutzen wollen. Man kann ihn nur für Gitea nutzen oder auch andere Services hosten. Hierfür würde ich empfehlen sich mehr in die [Nginx-Docs](https://nginx.org/en/docs/) einzulesen. Ich werde den Server so einrichten, dass nur Gitea drauf rennt.

Ganz nützlich ist es, wenn der Git Server eine Subdomain wie `git` bekommt. So muss nicht jedes Mal eine neue Domain gekauft werden, wenn wir irgendetwas neues machen wollen.

Keine Sorge das DBMS war das Schwerste :wink:.

Einfach Nginx installieren.

```
sudo apt install nginx
```

Erstelle die Datei `/etc/nginx/sites-available/gitea` und füge den Inhalt ein. Ändere den Wert `git.domain.com` mit deiner eigenen Domain.

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

Wir sind noch nicht ganz fertig, da uns ein SSL-Zertifikat noch fehlt.

Bitte nicht vergessen, dass wenn man ein Zertifikat haben will, stimmt man deren TOS zu.

Installiere `certbot` und hol dir ein Zertifikat.

```
sudo apt install certbot python3-certbot-nginx
sudo certbot certonly -d git.domain.com -m user@domain.com --agree-tos --standalone
```

Und zuletzt starte Nginx neu.

```
sudo systemctl restart nginx
```

### Gitea

Schau auf [https://dl.gitea.io/gitea/](https://dl.gitea.io/gitea/) nach, welche die neuste Version von Gitea ist und kopiere den Link.

Lade dir mit `wget` Gitea herunter.

```
wget -O gitea https://dl.gitea.io/gitea/1.16.9/gitea-1.16.9-linux-amd64
```

Installiere auf jeden Fall `git`.

```
sudo apt install git
```

Füge einen neuen Nutzer hinzu.

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

Setze die Berechtigungen.

```
sudo mkdir -p /var/lib/gitea/{custom,data,log}
sudo chown -R git:git /var/lib/gitea/
sudo chmod -R 750 /var/lib/gitea/
sudo mkdir /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea
```

Besuche die Seite von Gitea und richte die Information richtig ein.

Gitea hat während der Einrichtung die Berechtigungen vom Verzeichnis `/etc/gitea` geändert, also muss man diese nochmal setzen.

```
sudo chmod 750 /etc/gitea
sudo chmod 640 /etc/gitea/app.ini
```

[2]

Und falls alles geklappt hat, sollte der eigene Git-Server funktionieren :+1:. Zusätzliche Features können ebenfalls aktiviert werden, besuche einfach die [Dokumentation](https://docs.gitea.io/en-us/) von Gitea. Falls aber etwas nicht funktioniert hat, kann eine Suche im Internet oder auf Foren nicht schaden.

----

## Quellen

1. Database Preparation - Docs --> [Online](https://docs.gitea.io/en-us/database-prep/#postgresql)
2. Installation from binary --> [Online](https://docs.gitea.io/en-us/install-from-binary/)
3. Link zum Server --> [Online](https://git.mjindra.eu)
