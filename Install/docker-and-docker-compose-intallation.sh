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

# Install latest docker
curl https://get.docker.com | sh 
usermod -aG docker root

# This following script it's forked from https://gist.github.com/deviantony/2b5078fe1675a5fedabf1de3d1f2652a

# get latest docker compose released tag
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Install docker-compose
sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"

# Output docker version
docker -v
# Output compose version
docker-compose -v

exit 0