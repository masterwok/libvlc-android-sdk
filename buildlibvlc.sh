#!/bin/sh

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
fi

sh -c "cd ${rootdir}/vlc-android && ./compile.sh -l $*"
checkfail "./vlc-android/compile.sh $*"

aar_file=`ls "${rootdir}"/vlc-android/libvlc/build/outputs/aar/*.aar --sort=time|head -n 1`
cp "${aar_file}" "${rootdir}"/libvlc/libvlc-3.0.0.aar
checkfail "libvlc*.arr not found"