---
title: "Latex Editor"
summary: "Overleaf Community Editon"
---

My Online Latex Editor that uses
+ Overleaf Community Editon,
+ MongoDB as a DB and
+ Redis as a cache

and is set up with Docker.

Sample configuration:

```yml
mongo:
    expose:
    - 27017
    healthcheck:
      interval: 10s
      retries: 5
      test: echo 'db.stats().ok' | mongo localhost:27017/test --quiet
      timeout: 10s
    image: mongo:4.0
    volumes:
    - mongo_data:/data/db:rw
redis:
   image: redis
   volumes:
   - redis:/var/lib/redis:rw
 sharelatex:
   depends_on:
     mongo:
       condition: service_healthy
     proxy:
       condition: service_started
     redis:
       condition: service_started
   environment:
     EMAIL_CONFIRMATION_DISABLED: 'true'
     ENABLED_LINKED_FILE_TYPES: 'project_file,project_output_file'
     ENABLE_CONVERSIONS: 'true'
     LETSENCRYPT_EMAIL: max@mustermann.com
     LETSENCRYPT_HOST: latex.mustermann.com
     REDIS_HOST: redis
     SHARELATEX_ADMIN_EMAIL: max@mustermann.com
     SHARELATEX_APP_NAME: Overleaf Community Edition
     SHARELATEX_MONGO_URL: mongodb://mongo/sharelatex
     SHARELATEX_REDIS_HOST: redis
     SHARELATEX_SITE_URL: https://latex.mustermann.com
     TEXMFVAR: /var/lib/sharelatex/tmp/texmf-var
   image: sharelatex/sharelatex
   - mongo
   - redis
   ports:
   - 5000:80/tcp
   restart: always
   volumes:
   - sharelatex_data:/var/lib/sharelatex:rw
version: '2.1'
volumes:
  mongo_data: {}
  redis: {}
  sharelatex_data: {}
```

[Link](https://tex.derchef.site)
