#!/bin/bash

if [ "$#" -ne 1 ];then
	echo "Usage: $0 <android-9.0|android-8.1>"
	exit 1
fi

android_version="$1"

set -ex

cleanup() {
    bash
	if [ -n "$name" ];then
        docker kill "$name"
        docker rm "$name"
	fi
}

run_script () {
    docker exec "$name" sh -c "$1"
}

orig_docker="$(which docker)"
docker() {
    $orig_docker "$@"
}

trap 'cleanup' ERR
trap 'cleanup' EXIT

suffix="$(echo "$RANDOM" |md5sum |cut -c 1-8)"
name="phh-treble-$suffix"

echo "Running build on $name"

docker run --name "$name" --rm -d ubuntu:18.04 sleep infinity

docker exec "$name" echo "Good morning, now building"
run_script 'export DEBIAN_FRONTEND=noninteractive && dpkg --add-architecture i386 && \
	apt-get update && \
	(yes "" | apt-get install -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold" \
		build-essential \
		imagemagick \
		xorriso \
		locales \
		openjdk-8-jdk \
		python \
		git \
		m4 \
		unzip \
		bison \
		zip \
		gperf \
		libxml2-utils \
		zlib1g:i386 \
		libstdc++6:i386 \
		bc \
		curl \
		lzop \
		lzip \
		lunzip \
		squashfs-tools \
		sudo \
		repo \
		xmlstarlet \
		python-pip \
		python3-pip \
		git \
       wget )'

run_script '
	git config --global user.name "zhz8888" && \
	git config --global user.email "zhz1021@gmail.com" && \
	git config --global color.ui auto'

run_script 'curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash ; apt install git-lfs; git lfs install'

run_script 'git clone https://github.com/zhz8888/phh_GSI.git'

run_script '\
	mkdir build-dir && \
	sed -E -i "s/(repo sync.*)-j 1/\1-j128/g" phh_GSI/build.sh && \
	sed -E -i "s/(make.*)-j8/\1-j128/g" phh_GSI/build.sh
	'

run_script "cd build-dir && bash ../phh_GSI/build.sh $android_version"

docker cp "$name:"/build-dir/release release

