# Community

* IRC: irc://irc.freenode.net/#phh-treble
* WebIRC: http://webchat.freenode.net/?channels=%23phh-treble&uio=d4
* Matrix: #freenode_#phh-treble:matrix.org
* Telegram https://t.me/phhtreble
* xda-developers threads: https://forum.xda-developers.com/search.php?do=finduser&u=1915408&starteronly=1

# How to build

* clone this repository
* call the build scripts from a separate directory

For example:

```
git clone https://github.com/zhz8888/phh_GSI.git
sudo chmod -R 777 phh_GSI/
cd phh_GSI/
mkdir Work
sudo chmod -R 777 Work
cd Work
bash ../build-rom.sh android-10.0 lineage170
```

## More flexible build script

(this has been tested much less)

```
bash ../build-dakkar.sh aosp-10 arm64-aonly-gapps-nosu
```

The script should provide a help message if you pass something it doesn't understand

# Using Docker

clone this repository, then:

```
docker build -t treble docker/
docker container create --name treble treble
docker run -ti \
    -v $(pwd):/treble \
    -v $(pwd)/../treble_output:/treble_output \
    -w /treble_output \
    treble \
    /bin/bash /treble/build-dakkar.sh aosp10 \
    arm-aonly-gapps-su \
    arm64-ab-go-nosu
```

# Conventions for commit messages

* `[UGLY]` Please make this patch disappear as soon as possible
* `[master]` tag means that the commit should be dropped in a future rebase
* `[device]` tag means this change is device-specific workaround
* `::device name::` will try to describe which devices are concerned by this change
* `[userfriendly]` This commit is NOT used for hardware support, but to make the rom more user friendly
