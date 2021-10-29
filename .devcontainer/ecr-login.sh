#!/bin/bash

set -e

echo "(*) Starting login at $(date)"

# Get environment variable names with secrets in them
account_id_env_var=${1:-"ECR_ACCOUNT_ID"}
region_env_var=${2:-"ECR_REGION"}
access_key_id_env_var="${3:-"AWS_ACCESS_KEY_ID"}"
secret_access_key_env_var="${4:-"AWS_SECRET_ACCESS_KEY"}"

# Abort if reequired env vars not set
account_id="${!account_id_env_var}"
if [ -z "${account_id}" ]; then echo "(!) ${account_id_env_var} not set. Aborting."; exit 0; fi
region="${!region_env_var}"
if [ -z "${region}" ]; then echo "(!) ${region_env_var} not set. Aborting."; exit 0; fi
export AWS_ACCESS_KEY_ID="${!access_key_id_env_var}"
if [ -z "${AWS_ACCESS_KEY_ID}" ]; then echo "(!) ${access_key_id_env_var} not set. Aborting."; exit 0; fi
export AWS_SECRET_ACCESS_KEY="${!secret_access_key_env_var}"
if [ -z "${AWS_SECRET_ACCESS_KEY}" ]; then echo "(!) ${secret_access_key_env_var} not set. Aborting."; exit 0; fi

tmp_root="/tmp/__aws-tmp"

# Download aws CLI into temp spot if not found
if ! type aws > /dev/null 2>&1; then
    if [ ! -d "${tmp_root}/aws-cli" ]; then
        echo "(*) Installing AWS CLI in temp location..."
        mkdir -p "${tmp_root}"
        curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "${tmp_root}/awscliv2.zip"
        unzip "${tmp_root}/awscliv2.zip" -d "${tmp_root}"
        "${tmp_root}/aws/install" -i ${tmp_root}/aws-cli -b ${tmp_root}/bin
    fi
    export PATH="${PATH}:${tmp_root}/bin"
fi

# Login
aws ecr get-login-password --region ${region} | \
    docker login --username AWS --password-stdin ${account_id}.dkr.ecr.${region}.amazonaws.com

echo "(*) Logged in at $(date)"

