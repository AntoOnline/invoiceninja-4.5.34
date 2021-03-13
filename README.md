![Invoice Ninja Logo](https://anto.online/wp-content/uploads/2021/03/Invoice-Ninja-Header-Logo.png)

**This is not the official Invoice Ninja repo, please click [here](https://hub.docker.com/r/invoiceninja/invoiceninja) for supported images.**

# Overview #

Invoice Ninja is an open-source platform for invoicing, billing, and payment management. It has been designed to streamline and simplify the way freelancers and small to medium-sized businesses manage their invoices. Invoice Ninja will help you get paid for their products and services effortlessly. You can also integrate it with various payment gateways such as Stripe, and it is highly configurable. The team at Invoice Ninja has put together a great product!

Invoice Ninja v5.1.14 was available at the time of this build, but I decided to build the previous major release after numerous failed attempts to get it to run. I suggest your visit Invoice Ninja's [official Docker page](https://hub.docker.com/r/invoiceninja/invoiceninja) to see if their version works for you. If not: then you can try this image unsupported image. The intention here was to learn and get going fast. Therefore, do not expect any special environment config settings, etc. I will add some for Invoice Ninja 5.1.x.

Please read through all the steps to see if this build will suit you. One error occurs after the setup is completed, but it does not seem to limit usability.

The container runs on port 80 internally; also, you will be required to mount the /var/www locally.

Also, it is pre-installed with CRON and uses the following schedule to send reminders and invoices as 8pm:

````
0 8 * * * /usr/local/bin/php /var/www/artisan ninja:send-reminders > /dev/null
0 8 * * * /usr/local/bin/php /var/www/artisan ninja:send-invoices > /dev/null
````

# Install Process #

## Step 1 - Create the Database ##

Create the database and user using the following SQL commands:

````
CREATE USER 'ninja'@'%' IDENTIFIED BY 'ninja123';
CREATE DATABASE IF NOT EXISTS ninja CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES on ninja.* to 'ninja'@'%' WITH GRANT OPTION;
FLUSH privileges;
````

**Important:**
- Please change the password: "ninja123", to something more secure!

## Step 2 - Run the container ##

The image is stored in the Docker Hub at: [https://hub.docker.com/r/antoonline/invoiceninja-4.5.34](https://hub.docker.com/r/antoonline/invoiceninja-4.5.34).

You can use the following docker-compose.yml example to run your container:

````
version: '2'

services:
  app:
    image: 'antoonline/invoiceninja-4.5.34:latest'
    ports:
      - '8888:80'
    volumes:
      - /var/invoice-ninja:/var/www
````

You can run the compose file with: ````docker-compose up -d```` or something like Portainer.

You can also run it via the command line like this:

````
docker run -it -d -v /var/invoice-ninja:/var/www -p 8888:80 antoonline/invoiceninja-4.5.34:latest
````

Feel free to add your own MySQL and SSL containers as needed. The example above will allow you to connect to a remotely hosted MySQL database. You can, however, connect to any other MySQL host.

## Step 3 - Complete the Setup ##

You should now be able to access Invoice Ninja using your browser on port 8888. For example http://127.0.0.1:8888. If successful, then the site will redirect to http://127.0.0.1:8888/setup.

Now simply fill out the details and let Invoice Ninja create your /var/www/.env file. This file can be accessed via your local mount. The env file will contain all the config settings as well as a unique APP_KEY.

**Important:**
- You must complete the Invoice Ninja setup! If you don't then you will get the following error, when reloading the container:
````Error: app is already configured, backup then delete the .env file to re-run the setup````. If this happens, then simply delete the .env file from your local mount and reload the site.
- You will see a ````Undefined property: stdClass::$engine```` error after saving your config. This is an error presumably with the code.

## Step 4 - Login to Invoice Ninja ##

Ignore the error in the previous step and navigate your browser to: ````http://127.0.0.1:8888/login````.

# Additional Info # 

You may also want to check out: [how to setup Docker](https://anto.online/guides/setup-docker/) and [how to use Docker files](https://anto.online/guides/how-to-use-dockerfiles-in-docker/).