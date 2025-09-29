#!/bin/sh
#
# $Id: uninstall.sh 17950 2020-11-21 22:04:08Z NiLuJe $
#

# Pull libOTAUtils for logging & progress handling
[ -f ./libotautils ] && source ./libotautils


# Hack specific config (name and when to start/stop)
HACKNAME="linkss"
SLEVEL="73"
KLEVEL="08"

otautils_update_progressbar

# From v0.4.N
# Boot symlink
logmsg "I" "uninstall" "" "removing boot symlink from v0.4.N"
[ -h /etc/rcS.d/S90${HACKNAME} ] && rm -f /etc/rcS.d/S90${HACKNAME}

otautils_update_progressbar

# From v0.5.N
logmsg "I" "uninstall" "" "removing messed up symlinks from v0.5.N"
[ -h /etc/rc6.d/K8${HACKNAME} ] && rm -f /etc/rc6.d/K8${HACKNAME}
[ -h /etc/rc0.d/K8${HACKNAME} ] && rm -f /etc/rc0.d/K8${HACKNAME}
[ -h /etc/rc3.d/K8${HACKNAME} ] && rm -f /etc/rc3.d/K8${HACKNAME}

otautils_update_progressbar

# From v0.5.N
# Boot symlink
logmsg "I" "uninstall" "" "removing boot symlink"
[ -h /etc/rc5.d/S${SLEVEL}${HACKNAME} ] && rm -f /etc/rc5.d/S${SLEVEL}${HACKNAME}

otautils_update_progressbar

# Reboot symlink
logmsg "I" "uninstall" "" "removing reboot symlink"
[ -h /etc/rc6.d/K${KLEVEL}${HACKNAME} ] && rm -f /etc/rc6.d/K${KLEVEL}${HACKNAME}

otautils_update_progressbar

# Shutdown symlink
logmsg "I" "uninstall" "" "removing shutdown symlink"
[ -h /etc/rc0.d/K${KLEVEL}${HACKNAME} ] && rm -f /etc/rc0.d/K${KLEVEL}${HACKNAME}

otautils_update_progressbar

# Updater symlink
logmsg "I" "uninstall" "" "removing update symlink"
[ -h /etc/rc3.d/K${KLEVEL}${HACKNAME} ] && rm -f /etc/rc3.d/K${KLEVEL}${HACKNAME}

otautils_update_progressbar

# Remove our hack's init script
logmsg "I" "uninstall" "" "removing init script"
[ -f /etc/init.d/${HACKNAME} ] && rm -f /etc/init.d/${HACKNAME}

otautils_update_progressbar

# From v0.10.N
# Remove custom directory in userstore?
logmsg "I" "uninstall" "" "removing kual extension"
if [ -d /mnt/us/extensions/${HACKNAME} ] ; then
    rm -rf /mnt/us/extensions/${HACKNAME}
    logmsg "I" "uninstall" "" "kual extension has been removed"
fi
logmsg "I" "uninstall" "" "removing custom directory (only if /mnt/us/${HACKNAME}/uninstall exists)"
if [ -d /mnt/us/${HACKNAME} -a -f /mnt/us/${HACKNAME}/uninstall ] ; then
    rm -rf /mnt/us/${HACKNAME}
    logmsg "I" "uninstall" "" "custom directory has been removed"
fi

otautils_update_progressbar

logmsg "I" "uninstall" "" "done"

otautils_update_progressbar

return 0
