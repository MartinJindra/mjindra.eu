---
title: "Why Not to Use Wordpress"
date: "2022-06-28"
author: "Martin Jindra"
aliases: []
tags: []
description: ""
ShowToc: false
TocOpen: false
comments: false
draft: false
weight: 3
cover:
    image: "why-not-to-use-wordpress.png"
    relative: true
---

When a person wants to make his/her own blog or personal website, there are many options to choose from. Some may only want to make their own page, while others may want to make a complete blog where readers can subscribe to a newsletter, where you can comment down below and where the interface is easy to use. The latter is all well and good, but does it have to be so complicated?

Many pages on the internet are _dynamic websites_, which are websites that often have a complete setup behind them and show their content differently. A good example is Amazon. It displays what it thinks is best for the visitor. It changes its behavior depending on what you click on, whether you are logged in or not, or whether you enter something in the search. The content is never the same.

The most popular CMS (Content Management System) that manages websites is Wordpress. It's user numbers are incredibly large. According to an [estimate](https://w3techs.com/technologies/overview/content_management) by W<sup>3</sup>Techs, it is used by 43% of all websites. This has the major drawback that Wordpress is a big target for hackers. Not only is it big when it comes to user numbers, but it's also an "easy" one. In recent years, countless vulnerabilities and security holes have been found. This simply makes it unsafe to keep such a site online, especially if you forget to install updates in time. If you just look around a bit, you will always find cases of outdated wordpress blogs that have been taken over by hackers. Additionally, even a version that is kept up to date should still be properly secured. Long and hard to guess passwords should be used. One should change the login page address for admins and much more. That for just a simple blog?

In addition to the security issues, Wordpress also needs a full database like MySQL and a PHP setup. These two extras create more problems. You need more computer power because each page and request is output differently. The programs also need their share of the system's resources.

So is there an easy way to avoid these disadvantages, but still have a working website? But of course! For me, the answer is very simple. Namely _Hugo_. For those who don't know Hugo yet, here's a little explanation. Hugo is a _static website generator_. Static web pages are much lighter on computer resources than dynamic ones and the content always stays the same. Hugo creates a complete web page from a few configuration and content files and is super fast. Each website can use its own theme or an existing one. This website alone was generated with Hugo. For the many features it offers you, this text would have to be even longer. And from a security point of view alone, static websites are much better, since they are just a few HTML, CSS and JavaScript files.

If you want to try Hugo look at the [video](https://www.youtube.com/watch?v=hjD9jTi_DQ4) from _Envato Tuts+_
