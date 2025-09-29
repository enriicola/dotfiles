#!/bin/sh
#
# Python uninstaller
#
# $Id: uninstall.sh 17990 2020-12-15 00:49:05Z NiLuJe $
#
##

# Pull libOTAUtils for logging & progress handling
[ -f ./libotautils ] && source ./libotautils


HACKNAME="python"

otautils_update_progressbar

# Remove Python 2 symlinks
logmsg "I" "uninstall" "" "removing python 2 symlinks"
LIST="/usr/bin/python /usr/bin/python2 /usr/bin/python2.7"
for var in ${LIST} ; do
    if [ -L "${var}" ] ; then
        logmsg "I" "uninstall" "" "symbolic link ${var} -> $( readlink ${var} ) exists, deleting..."
        PYBIN="$( readlink ${var} )"
        if [ "${PYBIN}" == "/mnt/us/python/bin/python2.7" ] ; then
            rm -f "${var}"
        else
            logmsg "I" "uninstall" "" "symbolic link is not ours, skipping..."
        fi
    fi
done

otautils_update_progressbar

# Remove python 2 tree
logmsg "I" "uninstall" "" "removing existing python 2 tree..."
if [ -d "/mnt/us/python" ] ; then
    rm -rf "/mnt/us/python"
fi

otautils_update_progressbar

# Remove Python 3.7 symlinks
logmsg "I" "uninstall" "" "removing python 3.7 symlinks"
LIST="/usr/bin/python3 /usr/bin/python3.7 /usr/bin/python3.7m"
for var in ${LIST} ; do
    if [ -L "${var}" ] ; then
        logmsg "I" "uninstall" "" "symbolic link ${var} -> $( readlink ${var} ) exists, deleting..."
        PYBIN="$( readlink ${var} )"
        if [ "${PYBIN}" == "/mnt/us/python3/bin/python3.7" ] ; then
            rm -f "${var}"
        else
            logmsg "I" "uninstall" "" "symbolic link is not ours, skipping..."
        fi
    fi
done

otautils_update_progressbar

# Remove Python 3.8 symlinks
logmsg "I" "uninstall" "" "removing python 3.8 symlinks"
LIST="/usr/bin/python3 /usr/bin/python3.8"
for var in ${LIST} ; do
    if [ -L "${var}" ] ; then
        logmsg "I" "uninstall" "" "symbolic link ${var} -> $( readlink ${var} ) exists, deleting..."
        PYBIN="$( readlink ${var} )"
        if [ "${PYBIN}" == "/mnt/us/python3/bin/python3.8" ] ; then
            rm -f "${var}"
        else
            logmsg "I" "uninstall" "" "symbolic link is not ours, skipping..."
        fi
    fi
done

otautils_update_progressbar

# Remove Python 3.9 symlinks
logmsg "I" "uninstall" "" "removing python 3.9 symlinks"
LIST="/usr/bin/python3 /usr/bin/python3.9"
for var in ${LIST} ; do
    if [ -L "${var}" ] ; then
        logmsg "I" "uninstall" "" "symbolic link ${var} -> $( readlink ${var} ) exists, deleting..."
        PYBIN="$( readlink ${var} )"
        if [ "${PYBIN}" == "/mnt/us/python3/bin/python3.9" ] ; then
            rm -f "${var}"
        else
            logmsg "I" "uninstall" "" "symbolic link is not ours, skipping..."
        fi
    fi
done

otautils_update_progressbar

# Remove HTTPie symlinks
logmsg "I" "uninstall" "" "removing httpie symlinks"
LIST="http https"
for var in ${LIST} ; do
    if [ -L /usr/bin/${var} ] ; then
        echo "symbolic link /usr/bin/${var} -> $( readlink /usr/bin/${var} ) exists, deleting..." >> ${USBNET_LOG}
        SYMBIN=$( readlink /usr/bin/${var} )
        if [ "${SYMBIN}" = "/mnt/us/python3/bin/${var}" ] ; then
            rm -f /usr/bin/${var} >> ${USBNET_LOG} 2>&1 || exit ${ERR}
        else
            echo "symbolic link is not ours, skipping..." >> ${USBNET_LOG}
        fi
    fi
done

otautils_update_progressbar

# Remove python 3 tree
logmsg "I" "uninstall" "" "removing existing python 3 tree..."
if [ -d "/mnt/us/python3" ] ; then
    rm -rf "/mnt/us/python3"
fi

otautils_update_progressbar

logmsg "I" "uninstall" "" "done"

otautils_update_progressbar

return 0
