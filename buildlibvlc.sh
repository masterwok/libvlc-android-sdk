#!/bin/sh

tag='3.0.13'

rootdir=`dirname $0`

checkfail()
{
    if [ ! $? -eq 0 ];then
        echo "'$1' failed"
        exit 1
    fi
}

if [ ! -d "${rootdir}/vlc-android" ]; then
    echo "VLC Android source not found, cloning"
    git clone http://code.videolan.org/videolan/vlc-android.git
    checkfail "git clone"
    git -C ${rootdir}/vlc-android checkout tags/${tag}
    checkfail "git checkout"
fi

sh -c "cd ${rootdir}/vlc-android && ./compile.sh -l $* -r"
checkfail "./vlc-android/compile.sh $*"
