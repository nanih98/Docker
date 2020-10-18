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

echo ""

# Check that user is root
if [[ $EUID -ne 0 ]]
then
echo -e "The user is not ROOT, so it is not allowed to run the script"
echo -e "Try using sudo if your user are in sudoers"
exit 1
fi

echo -e "\e[31mFollowing the directions from Docker, I will not give Docker permissions to a non-root user. We also won't let a non-root user run docker-compose\e[m\n"

echo -e "\e[31mWARNING: Adding a user to the "docker" group will grant the ability to run
         containers which can be used to obtain root privileges on the
         docker host.
         Refer to https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface
         for more information.\e[m \n\n"

# Install latest docker
echo -e "\e[31mInstalling Docker...\e[m\n\n"
curl https://get.docker.com | sh
chmod +x /usr/bin/docker
chmod 700 /usr/bin/docker

# Get latest docker version
compose_version=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Install docker-compose
echo ""
echo -e "\e[31mInstalling docker-compose...\e[m"
sh -c "curl -L https://github.com/docker/compose/releases/download/${compose_version}/docker-compose-`uname -s`-`uname -m` > /usr/bin/docker-compose"
chmod +x /usr/bin/docker-compose

# Alternaive to non-root users
echo -e "\e[31mNON-ROOT USER\e[m"
cat << "EOF"
If you want to be able to run Docker and docker-compose with a non-Docker user ...
$ usermod -aG docker your_username
$ chmod 755 /usr/bin/docker
$ chmod 755 /usr/bin/docker-compose
$ MAYBE: ln -s /usr/bin/docker-compose /usr/local/bin/docker-compose
EOF

exit 0