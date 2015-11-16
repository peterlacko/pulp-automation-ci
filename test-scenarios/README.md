## Directory containing various pulp testing scenarios
Each directory contains 3 playbooks and should be executed in following order:
* `deploy.yml` contains commands for deploying pulp on Amazon ec2 cloud
* `configure.yml` installs pulp-server and it's plugins on provisioned server and configures it
* `run.yml` consists whatever you want to do with your server, ie. verify installation, run test suite, fill pulp database or verify data integrity

### Upgrade testing
#### single-node-upgrade-1
* `deploy.yml` -- provision server in ec2,
* `configure.yml` -- install and configure pulp in verion that you want to upgrade from,
* `run.yml` -- does nothing, TODO: populate pulp server db with all kinds of data.

#### single-node-upgrade-2
* `deploy.yml` -- does nothing so far,
* `configure.yml` -- updates pulp to required version and migrate databse,
* `run.yml` -- runs pulp-automation, TODO: data integrity test after migration
