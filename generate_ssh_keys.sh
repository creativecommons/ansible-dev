#!/bin/sh

# Define key parameters
KEY_PATH=./sysadmin-ssh-keys
KEY_FILENAME=rsa_sysadmin

# Create a directory to store the SSH keys if it doesn't exist
mkdir -p ${KEY_PATH}

# Generate SSH key pair only if they don't already exist
if [ ! -f ${KEY_PATH}/${KEY_FILENAME} ]
then
    ssh-keygen -b 4096 -t rsa -C sysadmin -f ${KEY_PATH}/${KEY_FILENAME} -N ''
    echo "SSH keys generated and stored in ${KEY_PATH}/${KEY_FILENAME}"
else
    echo "SSH keys already exist in ${KEY_PATH}/${KEY_FILENAME}"
fi

