## Setup for local deployment via ansible
* configure templated setEnv.sh.template file and source it
* copy your private key to .
* **Tags:** you can specify which tasks from playbook should run by --tags resp which should be skipped by --skip-tags, supported tags for playbooks are in []
* set up automation runner node as follows
    * `ansible-playbook -i ec2.py automation-runner-deploy.yml -e @global_vars.yml`
    * `ansible-playbook -i ec2.py automation-runner-configure.yml -e @global_vars.yml`
* Comment out test scenarios you don't want to run in automation-{deploy,configure,run}.yml files and then run
    * `ansible-playbook -i ec2.py automation-deploy.yml -e @global_vars.yml`
    * `ansible-playbook -i ec2.py automation-configure.yml -e @global_vars.yml`
    * `ansible-playbook -i ec2.py automation-run.yml -e @global_vars.yml` [run_automation]
* results will be present in local xml JUnit file
* for running sigle tests, try your own configuration, run commands, etc, you can still ssh into automation runner or automation node

## Setup for jenkins
Coming
 
#### Terminate selected instances
Add instances to terminate to playbook and run: 
* `ansible-playbook -i ec2.py ec2-terminate-all.yml -e @global_vars.yml`

### Config files
* ansible.cfg -- main ansible config file
* ec2.ini -- ansible dynamic inventory config file
* global_vars.yml -- global variables for use in all playbooks/roles

### Playbooks
* keypair-gen -- generate new keypair for use in automation, saved to ./keys/
* security-gropus-create -- create security gropus 'ssh' and 'pulp'
* reposerver -- deploys and configures machine for building pulp (+plugins) rpms from github and uploads them to repository on s3 bucket
* automation-runner-configure/deploy -- setup and creates nod for running automation
* automation-deploy/configure/run -- deploys, configure and runs all test scenarios enabled in config file
* ec2-terminate-all -- serves for terminating specified instances


## Obsolete - Pulp-automation deployment using ansible
* each deployment (specified by automation_name, including bucket) should be used for testing of single pulp version (ie. do not mix 2.7-testing with 2.7-devel) where different testing scenarios run from single automation node.
* ansible is idempotent, thus new nodes won't be deployed if node with given name already exists
* do not use dash '-' in name of nodes (including automation_name), use underscore instead
* as testing nodes are currently supported Fedora 20, 22, RedHat 7.1, as automation runner and reposerver Fedora only

Following test scenarios are currently supported:
* single-node: everything is running on single node. Upon each run pulp and pulp automation is updated to newest version and tests are running. This is simplest deployment, run it first.

### Obsolete - Usage
* copy templates of config files from temp/ directory to ansible/ dir
* export your credentials and set variables in cofig files (see below)
    * `export AWS_ACCESS_KEY_ID=<your_access_key>`
    * `export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>`
* copy your own private key to ./keys/ or generate new keypair using keypair-gen: 
    * `ansible-playbook keypair-gen.yml -e @global_vars.yml`
* create security groups for simple access and pulp (vars ssh_sg and pulp_sg)
    * `ansible-playbook security-groups-create.yml -e @global_vars.yml`

#### Obsolete - S3 repositories deploy, config & run
Setup node for building pulp rpms and create & configure S3 bucket as a pulp repo
run:
* `ansible-playbook -i ec2.py reposerver-deploy.yml -e @global_vars.yml`
* `ansible-playbook -i ec2.py reposerver-run.yml -e @global_vars.yml`
* file link.txt contains link to currently built documentation (http://s3-region-name.amazonaws.com/bucket_name/current/docs/index.html) and also link to repo file

