## Information

* Spotweb is configured as an open system after running docker-compose up, so everyone who can access can register an account (keep this in mind)
* If you want to use the Spotweb API, create a new user and use the API key associated with that user
* If you would like to save nzb files to disk for (e.g.) SABnzbd to be picked up, configure docker-compose.yml to mount e.g. /nzb to some directory where nzb's need to be saved, and configure Spotweb to save NZB's to this directory on disk

## Docker setup

I decided on the following setup for this Docker image:
* Image contains NGINX, PHP 7.1 and Crond
* For the database a MySQL image is used
* To prevent having to configure Spotweb manually `upgrade-db.php` is run to upgrade the database and reset the password for the admin user (so currently the `admin` always has password `spotweb`)
* Crond is used to run the `retrieve.php` script which updates Spotweb with the latest headers from a configured usenet server, the crontab is run every hour
* The only required manual configuration is setting up a valid usenet server
* Depending on what you like, you can mount the /nzb volume and let Spotweb save nzb's to that directory (e.g. mount /nzb to a folder watched by sabnzbd)
