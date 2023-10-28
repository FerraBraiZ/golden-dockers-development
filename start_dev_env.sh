#!/bin/bash -eu

# Check if an argument is provided
# Check if the argument is set (i.e., not empty)
if [ $# -eq 0 ] || [ -z "$1" ]; then
  echo "ERROR: No argument provided or the argument is empty."
  exit 1
fi

# Access the argument using $1 (the first argument)
arg=$1

# Check if the argument matches one of the languages
if [ "$arg" == "python" ] || [ "$arg" == "py" ]; then
  echo "You chose Python."
  echo
  # Add actions specific to Python here
elif [ "$arg" == "php" ] || [ "$arg" == "PHP" ]; then
  echo "You chose PHP."
  echo
  # Add actions specific to PHP here
elif [ "$arg" == "nodejs" ] || [ "$arg" == "node" ]; then
  echo "You chose Node.js."
  echo
  # Add actions specific to Node.js here
elif [ "$arg" == "golang" ] || [ "$arg" == "go" ]; then
  echo "You chose Go (Golang)."
  echo
  # Add actions specific to Go here
else
  echo "Unknown language: $arg!"
  echo
  echo "NOTICE: the available development environments are: python, php, go and nodejs"
  echo
  exit 0
fi


#-----------------------------------------------------------------------------------------------------------------
# Export Variables used in Docker build process
#-----------------------------------------------------------------------------------------------------------------
export DOCKER_BUILDKIT=1
export GROUP="docker"


#-----------------------------------------------------------------------------------------------------------------
#Create docker group
#-----------------------------------------------------------------------------------------------------------------
if ! grep -q $GROUP /etc/group; then
    echo "Criando grupo docker: ${GROUP}"
    echo
    sudo groupadd $GROUP
fi

#-----------------------------------------------------------------------------------------------------------------
#Add user to docker group and apply immediately
#-----------------------------------------------------------------------------------------------------------------
if ! groups $USER | grep &>/dev/null "\b${GROUP}\b"; then
    echo "Adicionando usuario grupo docker: ${USER}"
    echo
    sudo usermod -aG $GROUP $USER
    sudo newgrp $GROUP
fi

#-----------------------------------------------------------------------------------------------------------------
# Increate vm.max_map_count
#-----------------------------------------------------------------------------------------------------------------
if ! [[ `sysctl vm.max_map_count | awk -F' ' '{print $3}'` =~ 262144 ]]; then
    sudo sysctl -w vm.max_map_count=262144
fi


#-----------------------------------------------------------------------------------------------------------------
# Adding Github SSH key
#-----------------------------------------------------------------------------------------------------------------
ssh-keyscan github.com > ~/.ssh/known_hosts
echo "Host *\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config && chmod 600 ~/.ssh/config
eval `ssh-agent` && ssh-add


#-----------------------------------------------------------------------------------------------------------------
# Create a .conf file for nginx proxy-pass or fastcgi-pass
#-----------------------------------------------------------------------------------------------------------------
export UPSTREAM_APP="$arg-upstream-app"
export LANG=$arg

if [ "$arg" == "php" ] || [ "$arg" == "PHP" ]; then
  echo
  echo "NOTICE: Using default fastcgi pass to php-fpm nginx configuration"
  echo
else
  source ./nginx_proxy_pass.sh
fi


#-----------------------------------------------------------------------------------------------------------------
# Debug env vars
#-----------------------------------------------------------------------------------------------------------------
#printenv; exit 0;


#-----------------------------------------------------------------------------------------------------------------
# Run docker-compose to build and run the dockers
#-----------------------------------------------------------------------------------------------------------------
docker-compose -f  "docker-compose-${arg}.yaml" up --build --renew-anon-volumes  --remove-orphans



