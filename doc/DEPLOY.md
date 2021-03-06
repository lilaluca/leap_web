# Deployment #

LEAP Web is provisioned and run as part of the overall [LEAP platform](https://leap.se/en/docs/platform).
We strongly recomment using the whole Platform and following its instructions.
If you want to directly deploy the webapp never the less these instructions are
for you.

These instructions are targeting a Debian GNU/Linux system. You might need to
change the commands to match your own needs.

## Server Preperation ##

### Dependencies ##

The following packages need to be installed:

* git
* ruby (2.1.5)
* couchdb (if you want to use a local couch)
* bundler

### Setup Capistrano ###

We use puppet to deploy. But we also ship an example deploy.rb in
config/deploy.rb.example. Edit it to match your needs if you want to use
capistrano.

run `cap deploy:setup` to create the directory structure.

run `cap deploy` to deploy to the server.

## Customized Files ##

Please make sure your deploy includes the following files:

* `public/config/provider.json` -- provider bootstrap file.
* `config/couchdb.yml` -- normal webapp couchdb configuration.
* `config/couchdb.admin.yml` -- configuration used for rake tasks.

## Couch Security ##

We recommend against using an admin user for running the webapp. To avoid this
couch design documents need to be created ahead of time and the auto update
mechanism needs to be disabled. Take a look at `test/travis/setup_couch.sh`
for an example of securing the couch.

### DESIGN DOCUMENTS ###

After securing the couch design documents need to be deployed with admin
permissions. There are two ways of doing this:
 * rake couchrest:migrate_with_proxies
 * dump the documents as files with `rake couchrest:dump` and deploy them
   to the couch by hand or with puppet.

#### CouchRest::Migrate ####

The before_script block in .travis.yml illustrates how to do this:

```bash
mv test/config/couchdb.yml config/couchdb.yml
mv test/config/couchdb.admin.yml config/couchdb.admin.yml
bundle exec rake db:rotate          # create dbs
bundle exec rake couchrest:migrate  # run migrations
```

#### Deploy design docs from CouchRest::Dump ####

First of all we get the design docs as files:

```bash
# put design docs in /tmp/design
bundle exec rake couchrest:dump
```

Then we add them to files/design in the site_couchdb module in leap_platform
so they get deployed with the couch. You could also upload them using curl or
sth. similar.
