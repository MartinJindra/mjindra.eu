# [derchef.site](https://derchef.site)

My personal [website](https://derchef.site) created with Hugo.
The theme that is being used is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## how to build the site

### dependencies

Install the following dependencies on your system.

1. [Hugo](https://gohugo.io/getting-started/installing/#quick-install)
2. [Docker](https://docs.docker.com/engine/install/)
3. [Docker Compose](https://docs.docker.com/compose/install/)
4. [make](https://www.gnu.org/software/make/)

### building

To build the source code execute in the project directory

```
make build
```

In the newly created directory [public](public) you can see the html and js files.

If you only want to preview the website.

```
make serve
```

### deployment

The deployment of the website and comment server is done by Docker. All configuration is done in [docker-compose.yml](docker-compose.yml) and [.env](.env).

The [.env](.env) should include this options and change these values accordingly.

Values like `mysecret`, `password` and `secret_token` should be changed in production.

```
# website settings
REMARK_URL=http://remark42.localhost
SECRET=mysecret
SITE=remark

# admin settings
ADMIN_SHARED_ID=mysecretid
ADMIN_SHARED_EMAIL=max@mustermann.com
ADMIN_PASSWD=password

# authentications
AUTH_GITHUB_CID=secret_token
AUTH_GITHUB_CSEC=secret_token
AUTH_GOOGLE_CID=secret_token
AUTH_GOOGLE_CSEC=secret_token
```

To checkout how a sample would run on a server execute

```
make dummy
```

If you enter your own values in [.env](.env) execute

```
make up
```

### shutting down

```
make down
```

