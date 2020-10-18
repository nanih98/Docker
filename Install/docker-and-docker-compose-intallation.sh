#!/bin/bash
set -e

cat << "EOF"
.########...#######...######..##....##.########.########.
.##.....##.##.....##.##....##.##...##..##.......##.....##
.##.....##.##.....##.##.......##..##...##.......##.....##
.##.....##.##.....##.##.......#####....######...########.
.##.....##.##.....##.##.......##..##...##.......##...##..
.##.....##.##.....##.##....##.##...##..##.......##....##.
.########...#######...######..##....##.########.##.....##
EOF

# Check that user is root 
if [[ $EUID -ne 0 ]]
then
echo -e "The user is not ROOT, so it is not allowed to run the script"
echo -e "Try using sudo if your user is in sudoers"
exit 1
fi

# Install latest docker
curl https://get.docker.com | sh 
usermod -aG docker root
# Only allow docker command for root (for production environment)
chmod 700 /usr/bin/docker

# This following script it's forked from https://gist.github.com/deviantony/2b5078fe1675a5fedabf1de3d1f2652a

# Get latest docker compose released tag
compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Install docker-compose
# Ask if you want to install docker only for root PATH
read -p "Do you want to install docker only for root? Type [yes/no]: " answer 
echo -e "Remember that if you enable the docker command for any user, they will be able to manage the containers \n"

if [ $answer == "yes"]; then
    sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose"
    chmod +x /usr/bin/docker-compose 
else 
    sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
    chmod +x /usr/local/bin/docker-compose
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
fi 

# Output docker version
docker -v
# Output compose version
docker-compose -v

exit 0
