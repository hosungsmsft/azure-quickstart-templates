#!/bin/bash

set -ex

PAYARA_ADMIN="payaraadmin"
HOME_DIR="/home/$PAYARA_ADMIN"
PAYARA_ADMIN_ID_RSA_PATH="$HOME_DIR/.ssh/payara_id_rsa"

function install_packages
{
    apt -y update
    apt -y upgrade
    apt -y install openjdk-8-jdk-headless unzip
}

function download_payara
{
    cd $HOME_DIR
    rm -rf payara5
    wget http://central.maven.org/maven2/fish/payara/distributions/payara/5.182/payara-5.182.zip
    unzip payara-5.182.zip
}

function start_payara_admin_server
{
    cd $HOME_DIR/payara5
    sudo -u $PAYARA_ADMIN ./asadmin start-domain production
}

function install_ssh_private_key
{
    local ssh_priv_key_b64=${1}

    echo $ssh_priv_key_b64 | base64 -d > $PAYARA_ADMIN_ID_RSA_PATH
    chown ${PAYARA_ADMIN}:${PAYARA_ADMIN} $PAYARA_ADMIN_ID_RSA_PATH
    chmod 400 $PAYARA_ADMIN_ID_RSA_PATH
}

machine_type=${1}
server_name_prefix=${2}
server_count=${3}
ssh_priv_key_b64=${4}

install_packages    # Should be done on both controller and server

if [ "$machine_type" = "controller" ]; then
    download_payara
    install_ssh_private_key $ssh_priv_key_b64
    start_payara_admin_server
fi
