# derchef.site

My personal [website](https://derchef.site) created with Hugo.
The theme that is being used is [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod)

## how to build the site

### dependencies

Install the following dependencies on your system.

1. [Hugo](https://gohugo.io/getting-started/installing/#quick-install)
2. [Docker](https://docs.docker.com/engine/install/)

### building

Clone the repository recursively to also download the hugo theme.

Change the working directory.

```
git clone https://git.derchef.site/derchef/derchef.site.git --recursive
cd derchef.site
```

Build the site.

```
hugo
```

In the newly created directory [public](public) you can see the html and js files.

Or serve the site so that you can visit the site on [localhost:1313](localhost:1313).

```
hugo server
```

### deployment

The deployment of the website and comment server is done by Docker.

To configure the comment server create a [.env](.env) file and paste the sample configuration into the file.

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

And when everything is finished you can start both applications with a

```
docker-compose up -d
```
