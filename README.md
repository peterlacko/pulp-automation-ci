## Spin up and configure instances for pulp server via ansible
This repository contains multiple possible configurations for setting up pulp on
ec2 including running pulp automation and jenkins deployment.

### Prerequisites
* ec2 credentials and RHN credentials.
* ec2 keypair in selected region.
* ansible 1.9.x installed on your computer

### Setup single pulp node on ec2, without running automation
* Clone repository using git clone:
    `git clone https://github.com/peterlacko/pulp-automation-ci`
* Copy your private key to `pulp-automation-ci/keys` directory.
* Set variables in `setEnv.sh` file and source the file. Configuration options are described within file itself.
* Optionally modify `general-deploy.yml` and `general-configure.yml` playbooks.
* To deploy machine in ec2 cloud, run:
    `ansible-playbook -i ec2.py --extra-vars "@global_vars.yml" general-deploy.yml`
* To install and configure pulp on deployed machine run
    `ansible-playbook -i ec2.py --extra-vars "@global_vars.yml" general-configure.yml`
* Now you can access server by it's public dns name, ie. to ssh into it, run:
    `ssh -i <you private key> root@ec2-xx-xx-xx-xx.eu-west-1.compute.amazonaws.com`

### Playbooks
* `general-deploy.yml` -- deploy single ec2 server,
* `general-configure.yml` -- configure that server,
* `test-scenarios/` -- playbooks in this directory test various scenarios of pulp deployment, including running pulp-automation
* `automation-{deploy,configure,run}.yml` -- run playbooks in test-scenarios directory
* `keypair-gen.yml` -- generate new keypair for use in automation, saved to ./keys/
* `security-gropus-create.yml` -- create security gropus 'ssh' and 'pulp'
* `automation-runner-configure/deploy.yml` -- setup and creates nod for running automation
* `ec2-terminate-all.yml` -- serves for terminating specified instances
* `reposerver-{deploy,run}` -- deploys and configures machine for building pulp (+plugins) rpms from github and uploads them to repository on s3 bucket

#### Terminate selected instances
Add instances to terminate to playbook and run: 
* `ansible-playbook -i ec2.py ec2-terminate-all.yml -e @global_vars.yml`
Instances to terminate are specified by it's tag name. To get list of all instancesrun
    ./ec2.py --list

### Config files
* `setEnv.sh` -- main deployment configuration file
* `ansible.cfg` -- main ansible config file
* `ec2.ini` -- ansible dynamic inventory config file
* `global_vars.yml` -- reads variables from environment. Usually you won't need to modify the file.

### OBSOLETE -Deploy machine, install and configure pulp
* configure setEnv.sh.template file and source it
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


### OBSOLETE - Pulp-automation deployment using ansible
* each deployment (specified by automation_name, including bucket) should be used for testing of single pulp version (ie. do not mix 2.7-testing with 2.7-devel) where different testing scenarios run from single automation node.
* ansible is idempotent, thus new nodes won't be deployed if node with given name already exists
* do not use dash '-' in name of nodes (including automation_name), use underscore instead
* as testing nodes are currently supported Fedora 20, 22, RedHat 7.1, as automation runner and reposerver Fedora only

Following test scenarios are currently supported:
* single-node: everything is running on single node. Upon each run pulp and pulp automation is updated to newest version and tests are running. This is simplest deployment, run it first.

### OBSOLETE - Usage
* copy templates of config files from temp/ directory to ansible/ dir
* export your credentials and set variables in cofig files (see below)
    * `export AWS_ACCESS_KEY_ID=<your_access_key>`
    * `export AWS_SECRET_ACCESS_KEY=<your_secret_access_key>`
* copy your own private key to ./keys/ or generate new keypair using keypair-gen: 
    * `ansible-playbook keypair-gen.yml -e @global_vars.yml`
* create security groups for simple access and pulp (vars ssh_sg and pulp_sg)
    * `ansible-playbook security-groups-create.yml -e @global_vars.yml`

### OBSOLETE - S3 repositories deploy, config & run
Setup node for building pulp rpms and create & configure S3 bucket as a pulp repo
run:
* `ansible-playbook -i ec2.py reposerver-deploy.yml -e @global_vars.yml`
* `ansible-playbook -i ec2.py reposerver-run.yml -e @global_vars.yml`
* file link.txt contains link to currently built documentation (http://s3-region-name.amazonaws.com/bucket_name/current/docs/index.html) and also link to repo file

