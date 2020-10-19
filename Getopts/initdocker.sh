#!/bin/bash
set -e 

if [[ $EUID -ne 0 ]]
then
echo -e "The user is not ROOT, so it is not allowed to run the script"
exit 1
fi

usage() {

  echo >&2
  echo "Usage: ${0} [-prduk]" >&2
  echo '  -p  Pull images of all the containers' >&2
  echo '  -r  Docker compose restart' >&2
  echo '  -d  Docker compose down' >&2
  echo '  -u  Docker compose up' >&2
  echo '  -k Delete docker container' >&2
  exit 1
}

while getopts prdufk OPTION
do
  case ${OPTION} in
    p) pull='true' ;;
    r) restart='true' ;;
    d) down='true' ;;
    u) up='true' ;;
    f) flush='true' ;;
    k) kill='true' ;;
    ?) usage ;;
  esac
done

#shift "$(( OPTIND - 1 ))"

if [[ "${#}" < 1 ]]
then
  usage
fi

#Pull all images of your current running containers
if [[ "${pull}" = 'true' ]]; then
echo -e "Pulling all the images for containers:\n"
docker ps | awk '{print $2}' | tail -n +2
echo -e "\n"
sleep 2
for i in $(docker ps | awk '{print $2}' | tail -n +2); do docker pull $i ; done
# Recreate containers with the new image
docker-compose up -d
# Clean up old container
docker system prune -f
fi

#Restart docker
if [[ "${restart}" = 'true' ]]; then
docker-compose restart
fi

# Docker compose down
if [[ "${down}" = 'true' ]]; then
docker-compose down
fi

# Docker compose up
if [[ "${up}" = 'true' ]]; then
docker-compose up -d
fi

if [[ "${kill}" = 'true' ]]; then
echo "Current containers (also dead ones)"
docker ps -a --format '{{.Names}}'
read -p "Enter the container you want to delete: " container
docker rm -fv $container
fi

exit 0
