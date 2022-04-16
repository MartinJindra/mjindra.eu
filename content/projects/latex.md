---
title: "Latex Editor"
summary: "Overleaf Community Editon"
#date: 2022-01-18T21:56:20+01:00
---

My Online Latex Editor that uses
+ Overleaf Community Editon,
+ MongoDB as a DB and
+ Redis as a cache

and is set up with Docker.

Sample configuration:

```yml
name: overleaf
services:
  mongo:
    expose:
    - "27017"
    healthcheck:
      test:
      - CMD-SHELL
      - echo 'db.stats().ok' | mongo localhost:27017/test --quiet
      timeout: 10s
      interval: 10s
      retries: 5
    image: docker.io/mongo:4.0
    networks:
      default: null
    restart: always
    volumes:
    - type: volume
      source: mongo
      target: /data/db
      volume: {}
  redis:
    expose:
    - "6379"
    image: docker.io/redis:5
    networks:
      default: null
    restart: always
    volumes:
    - type: volume
      source: redis
      target: /data
      volume: {}
  sharelatex:
    depends_on:
      mongo:
        condition: service_healthy
      proxy:
        condition: service_started
      redis:
        condition: service_started
    environment:
      EMAIL_CONFIRMATION_DISABLED: '''true'''
      ENABLE_CONVERSIONS: '''true'''
      ENABLED_LINKED_FILE_TYPES: '''project_file,project_output_file'''
      REDIS_HOST: redis
      SHARELATEX_ADMIN_EMAIL: test@gmail.com
      SHARELATEX_APP_NAME: Overleaf Community Edition
      SHARELATEX_MONGO_URL: mongodb://mongo/sharelatex
      SHARELATEX_REDIS_HOST: redis
      SHARELATEX_SITE_URL: http://latex.localhost
      TEXMFVAR: /var/lib/sharelatex/tmp/texmf-var
    image: docker.io/sharelatex/sharelatex
    links:
    - mongo
    - redis
    networks:
      default: null
    ports:
    - mode: ingress
      target: 80
      published: "5000"
      protocol: tcp
    restart: always
    volumes:
    - type: volume
      source: sharelatex
      target: /var/lib/sharelatex
      volume: {}
networks:
  default:
    name: overleaf_default
volumes:
  mongo:
    name: overleaf_mongo
  redis:
    name: overleaf_redis
  sharelatex:
    name: overleaf_sharelatex
```

[Link](https://tex.derchef.site)
