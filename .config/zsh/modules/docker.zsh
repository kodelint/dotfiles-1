# -----------------------------------------------------------------------------
# docker zsh aliases {{{

# docker
# alias d="docker"
# alias ds="docker-stable"

# docker alias
# Images
alias doi="docker images" # Get images
# Containers
alias dpa="docker ps -a" # Get container process
alias dl="docker ps -l -q" # Get latest container ID
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'" # Get container IP
alias drmac='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)' # Stop and Remove all containers
alias dst='docker stop'
# Inspections
alias drd="docker run -d -P" # Run deamonized container, e.g., $dkd base /bin/echo hello
alias dri='docker run --rm -i -t -P' # Run interactive container, e.g., $dki base /bin/bash

# Docker functions

# build dockerfile
dbu() { docker build --rm -t="$1" $2 .; }
# Run docker container
drun() { docker run --rm  $@;}
# Run docker container with interactive and allocate a pseudo-tty
druni() { docker run --rm -it $@;}
# Start all containers
dstart() { "docker" start $("docker" ps -a -q); }
# Stop all containers
dstop() { docker stop "$(docker ps -a -q)"; }
# Remove all stop container
drmstop() { docker rm $(docker ps -a | grep -v Up | awk 'NR>1 {print $1}') }
# Remove none tag images
drminone() { docker rmi $(docker images | awk '/^<none>/ { print $3 }'); }
# docker-machine ssh wrapper
dms() { MACHINE_DEBUG=0 docker-machine ssh "$1" sudo docker run --rm -it "$2" "$3" ; }

# dangerous functions
drmall() { docker rm "$(docker ps -a -q)"; } # Remove all containers
driall() { docker rmi $(docker images -q); } # Remove all images

# Show all alias related docker
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }


# docker-machine
alias dm="docker-machine"
alias machine="docker-machine"
alias dmls="dm ls"
alias dmrm="dm rm"

# docker-compose
# alias dc="CURL_CA_BUNDLE= docker-compose --verbose"
# alias compose="CURL_CA_BUNDLE= docker-compose --verbose"
alias dcb="docker-compose build --force-rm"
alias dcu="docker-compose up"
alias dcud="docker-compose up -d"

# }}}
# -----------------------------------------------------------------------------
[[ $ZSH_DEBUG = '1' ]] && echo 'Finished $HOME/.zsh/modules/docker.zsh'
# vim:ft=zsh:sts=2:sw=2:ts=2:et
