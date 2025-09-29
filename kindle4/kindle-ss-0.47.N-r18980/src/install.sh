#!/bin/sh
#
# $Id: install.sh 12287 2015-08-23 14:41:20Z NiLuJe $
#

# Pull libOTAUtils for logging & progress handling
[ -f ./libotautils ] && source ./libotautils


# Hack specific config (name and when to start/stop)
HACKNAME="linkss"
SLEVEL="73"
KLEVEL="08"

otautils_update_progressbar

# Remove our deprecated content
# From v0.4.N
logmsg "I" "install" "" "removing deprecated symlinks (v0.4.N)"
[ -h /etc/rcS.d/S90${HACKNAME} ] && rm -f /etc/rcS.d/S90${HACKNAME}

otautils_update_progressbar

# From v0.5.N
logmsg "I" "install" "" "removing deprecated symlinks (v0.5.N)"
[ -h /etc/rc6.d/K8${HACKNAME} ] && rm -f /etc/rc6.d/K8${HACKNAME}
[ -h /etc/rc0.d/K8${HACKNAME} ] && rm -f /etc/rc0.d/K8${HACKNAME}
[ -h /etc/rc3.d/K8${HACKNAME} ] && rm -f /etc/rc3.d/K8${HACKNAME}

otautils_update_progressbar

# From v0.13.N
logmsg "I" "install" "" "removing deprecated config files (v0.13.N)"
HACK_CFGLIST="prettyversion.txt"
for hack_cfg in ${HACK_CFGLIST} ; do
    [ -f /mnt/us/${HACKNAME}/bin/${hack_cfg} ] && rm -f /mnt/us/${HACKNAME}/bin/${hack_cfg}
done

otautils_update_progressbar

# From v0.33.N
logmsg "I" "install" "" "removing deprecated binaries (v0.33.N)"
HACK_CFGLIST="prettyversion.txt"
if [ -f /mnt/us/${HACKNAME}/bin/mobi_unpack.py ] ; then
    rm -f /mnt/us/${HACKNAME}/bin/mobi_unpack.py
fi
if [ -f /mnt/us/${HACKNAME}/bin/mobi_unpack.pyc ] ; then
    rm -f /mnt/us/${HACKNAME}/bin/mobi_unpack.pyc
fi
if [ -f /mnt/us/${HACKNAME}/bin/mobi_unpack.pyo ] ; then
    rm -f /mnt/us/${HACKNAME}/bin/mobi_unpack.pyo
fi

otautils_update_progressbar

# From v0.35.N
logmsg "I" "install" "" "removing deprecated files (old imagemagick config)"
if [ -d /mnt/us/${HACKNAME}/etc/ImageMagick ] ; then
    rm -rf /mnt/us/${HACKNAME}/etc/ImageMagick
fi

otautils_update_progressbar

# Install our hack's custom content
# But while trying to keep the user's custom content...
if [ -d /mnt/us/${HACKNAME} ] ; then
    logmsg "I" "install" "" "our custom directory already exists, checking if we have custom content to preserve"
    # Custom Screensavers
    if [ "x$( ls -A /mnt/us/${HACKNAME}/screensavers 2> /dev/null )" != x ] ; then
        # If we already have a non-empty custom ss dir, exclude the default custom ss from our archive
        HACK_EXCLUDE="${HACKNAME}/screensavers/00_you_can_delete_me.png"
        logmsg "I" "install" "" "found custom screensavers, excluding default custom screensaver"
    fi
    # If we disabled autoreboot, don't re-enable it...
    if [ ! -f /mnt/us/${HACKNAME}/autoreboot ] ; then
        HACK_EXCLUDE="${HACK_EXCLUDE} ${HACKNAME}/autoreboot"
        logmsg "I" "install" "" "keep autoreboot status (off)"
    fi
fi

otautils_update_progressbar

# Okay, now we can extract it. Since busybox's tar is very limited, we have to use a tmp directory to perform our filtering
logmsg "I" "install" "" "installing custom directory"
# Make sure our xzdec binary is executable first...
chmod +x ./xzdec
./xzdec ${HACKNAME}.tar.xz | tar -xvf -
# Do check if that went well
_RET=$?
if [ ${_RET} -ne 0 ] ; then
    logmsg "C" "install" "code=${_RET}" "failed to extract custom directory in tmp location"
    return 1
fi

cd src
# And now we filter the content to preserve user's custom content
for custom_file in ${HACK_EXCLUDE} ; do
    if [ -f "./${custom_file}" ] ; then
        logmsg "I" "install" "" "preserving custom screensavers"
        rm -f "./${custom_file}"
    fi
done
# Finally, unleash our filtered dir on the live userstore
cp -af . /mnt/us/
_RET=$?
if [ ${_RET} -ne 0 ] ; then
    logmsg "C" "install" "code=${_RET}" "failure to update userstore with custom directory"
    return 1
fi
cd - >/dev/null
rm -rf src

otautils_update_progressbar

# Install our hack's init script
logmsg "I" "install" "" "installing init script"
cp -f ${HACKNAME}-init /etc/init.d/${HACKNAME}

otautils_update_progressbar

# Make it executable
logmsg "I" "install" "" "chmoding init script"
[ -x /etc/init.d/${HACKNAME} ] || chmod +x /etc/init.d/${HACKNAME}

otautils_update_progressbar

# Make it start at boot (rc5), after dbus and before the framework
logmsg "I" "install" "" "creating boot runlevel symlink"
[ -h /etc/rc5.d/S${SLEVEL}${HACKNAME} ] || ln -fs /etc/init.d/${HACKNAME} /etc/rc5.d/S${SLEVEL}${HACKNAME}

otautils_update_progressbar

# Make it stop at reboot (rc6), after the framework and before userstore
logmsg "I" "install" "" "creating reboot runlevel symlink"
[ -h /etc/rc6.d/K${KLEVEL}${HACKNAME} ] || ln -fs /etc/init.d/${HACKNAME} /etc/rc6.d/K${KLEVEL}${HACKNAME}

otautils_update_progressbar

# Make it stop at shutdown (rc0), after the framework and before userstore
logmsg "I" "install" "" "creating shutdown runlevel symlink"
[ -h /etc/rc0.d/K${KLEVEL}${HACKNAME} ] || ln -fs /etc/init.d/${HACKNAME} /etc/rc0.d/K${KLEVEL}${HACKNAME}

otautils_update_progressbar

# Make it stop when updating (rc3), after the framework and before the updater
logmsg "I" "install" "" "creating update runlevel symlink"
[ -h /etc/rc3.d/K${KLEVEL}${HACKNAME} ] || ln -fs /etc/init.d/${HACKNAME} /etc/rc3.d/K${KLEVEL}${HACKNAME}

otautils_update_progressbar

# Generating Python bytecode for Mobi Unpack
logmsg "I" "install" "" "generating python bytecode"
# We need python, of course ;)
if [ -f "/mnt/us/python/bin/python2.7" ] ; then
    /mnt/us/python/bin/python2.7 -m py_compile /mnt/us/${HACKNAME}/bin/kindleunpack.py /mnt/us/${HACKNAME}/bin/mobi_uncompress.py /mnt/us/${HACKNAME}/bin/path.py /mnt/us/${HACKNAME}/bin/utf8_utils.py
    /mnt/us/python/bin/python2.7 -O -m py_compile /mnt/us/${HACKNAME}/bin/kindleunpack.py /mnt/us/${HACKNAME}/bin/mobi_uncompress.py /mnt/us/${HACKNAME}/bin/path.py /mnt/us/${HACKNAME}/bin/utf8_utils.py
fi

otautils_update_progressbar

# Cleanup
logmsg "I" "install" "" "cleaning up"
rm -f ${HACKNAME}-init ${HACKNAME}.tar.xz xzdec

otautils_update_progressbar

logmsg "I" "install" "" "done"

otautils_update_progressbar

return 0
