#!/bin/sh
# modify this file as you wish
export AWS_SECRET_ACCESS_KEY=<put your credentials>
export AWS_ACCESS_KEY_ID=<put your credentials>
# RHN credentials
export RHN_USERNAME=<rhn username>
export RHN_PASSWORD=<rhn password>
export RHN_POOLID=<rhn poolid>
# key name for communication with instances used within ec2, file name should be as $EC2_KEY_NAME.pem
export EC2_KEY_NAME=
export FORCE_KEYPAIR='False'
# use m3.xlarge instead for automation runner
export EC2_INSTANCE_TYPE='m3.large'
export EC2_REGION='eu-west-1'
export EC2_SSH_SG='ssh' # ssh + https
export EC2_PULP_SG='pulp' # ssh + https + pulp

# set EC2_TESTING_NODE for working with general-configure and general-deploy playbooks
export EC2_TESTING_NODE=<machine tag name here, ie: pulp2_7_fedora22_testing>
# set AUTOMATION_NAME if you wish to work with playbooks inside 'test-scenarios' directory
export AUTOMATION_NAME=<put name of your automation here>

####################################################
# stable, beta or testing: https://repos.fedorapeople.org/repos/pulp/pulp/testing/automation/
# set beta OR (exclusive) stable to True, or both to False
export PULP_TEST_BETA='True'
export PULP_TEST_STABLE='False'
# rhel6, rhel7 or fedora22
export EC2_PULP_OS='rhel7'
####################################################
####### Single node latest variables ###############
# Sets variables for general-{deploy,configure} ####
# as well ##########################################
# default options: test pulp 2.7 beta on rhel7 #####
export TESTED_VERSION='2.7'
# set beta OR (exclusive) stable to True, or both to False
export PULP_TEST_BETA='True'
export PULP_TEST_STABLE='False'
####################################################
####### Upgrade testing variables ##################
####### Only upgrade testing scenario ##############
# defaults: test upgrade of pulp 2.6 stable rel. ###
#           to 2.7 beta                            #
export UPGRADING_FROM='2.6'
export UPGRADING_FROM_BETA='False'
export UPGRADING_FROM_STABLE='True'
export UPGRADING_TO='2.7'
export UPGRADING_TO_BETA='True'
export UPGRADING_TO_STABLE='False'
####################################################
