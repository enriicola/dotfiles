#!/bin/sh
#
# Python installer
#
# $Id: install.sh 18405 2021-04-07 17:05:49Z NiLuJe $
#
##

# Pull libOTAUtils for logging & progress handling
[ -f ./libotautils ] && source ./libotautils


HACKNAME="python"
PY3_VER="3.9"

otautils_update_progressbar

# Remove Python 3.7 symlinks
if [ -f "./PY3" ] ; then
    logmsg "I" "uninstall" "" "removing python 3.7 symlinks"
    LIST="/usr/bin/python3 /usr/bin/python3.7 /usr/bin/python3.7m"
    for var in ${LIST} ; do
        if [ -L "${var}" ] ; then
            logmsg "I" "uninstall" "" "symbolic link ${var} -> $( readlink ${var} ) exists, deleting..."
            PYBIN="$( readlink ${var} )"
            if [ "${PYBIN}" = "/mnt/us/python3/bin/python3.7" ] ; then
                rm -f "${var}"
            else
                logmsg "I" "uninstall" "" "symbolic link is not ours, skipping..."
            fi
        fi
    done
fi

otautils_update_progressbar

# Remove Python 3.8 symlinks
if [ -f "./PY3" ] ; then
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
fi

otautils_update_progressbar

# Remove existing python 2 install
if [ -f "./PY2" ] ; then
    logmsg "I" "install" "" "removing existing python install..."
    if [ -d "/mnt/us/python" ] ; then
        rm -rf "/mnt/us/python"
    fi
fi

otautils_update_progressbar

# Remove existing python 3 install
if [ -f "./PY3" ] ; then
    logmsg "I" "install" "" "removing existing python 3 install..."
    if [ -d "/mnt/us/python3" ] ; then
        rm -rf "/mnt/us/python3"
    fi
fi

otautils_update_progressbar

# Make sure we have enough space left (>175MB) in the userstore to unpack & generate the bytecode...
logmsg "I" "install" "" "checking amount of free storage space..."
if [ "$(df -k /mnt/us | awk '$3 ~ /[0-9]+/ { print $4 }')" -lt "179200" ] ; then
    logmsg "C" "install" "code=1" "not enough space left in the userstore"
    # Cleanup & exit w/ prejudice
    rm -f "VERSION" "${HACKNAME}.tar.xz" "${HACKNAME}3.tar.xz" "xzdec" "PY2" "PY3"
    return 1
fi

otautils_update_progressbar

# Install Python 2 in the userstore (we don't setup any symlinks in PATH for now)
if [ -f "./PY2" ] ; then
    logmsg "I" "install" "" "unpacking python 2..."
    # Make sure our xzdec binary is executable first...
    chmod +x ./xzdec
    ./xzdec "${HACKNAME}.tar.xz" | tar -xvf - -C /mnt/us/
    _RET=$?
    if [ ${_RET} -ne 0 ] ; then
        logmsg "C" "install" "code=${_RET}" "failed to update userstore with custom directory"
        return 1
    fi
fi

otautils_update_progressbar

# Generate Python 2 bytecode (standard lib)
if [ -f "./PY2" ] ; then
    logmsg "I" "install" "" "generating bytecode (std lib) ..."
    /mnt/us/python/bin/python2.7 -m compileall -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data|test|tests' /mnt/us/python/lib/python2.7
    _RET=$?
    if [ ${_RET} -ne 0 ] ; then
        logmsg "C" "install" "code=${_RET}" "failed to generate python bytecode for the standard lib"
        return 1
    fi
fi

otautils_update_progressbar

# Generate Python 2 bytecode (third-party modules)
if [ -f "./PY2" ] ; then
    logmsg "I" "install" "" "generating bytecode (3rd party) ..."
    /mnt/us/python/bin/python2.7 -m compileall -f -x badsyntax /mnt/us/python/lib/python2.7/site-packages
    _RET=$?
    if [ ${_RET} -ne 0 ] ; then
        logmsg "C" "install" "code=${_RET}" "failed to generate python bytecode for third-party modules"
        return 1
    fi
fi

otautils_update_progressbar

# Symlinks setup...
if [ -f "./PY2" ] ; then
    logmsg "I" "install" "" "installing python 2 symlinks"
    LIST="/usr/bin/python /usr/bin/python2 /usr/bin/python2.7"
    for var in ${LIST} ; do
        if [ -L "${var}" ] ; then
            logmsg "I" "install" "" "symbolic link ${var} -> $( readlink ${var} ) already exists, skipping..."
        else
            if [ -x "${var}" ] ; then
                logmsg "I" "install" "" "binary ${var} already exists, skipping..."
            else
                logmsg "I" "install" "" "creating ${var} symbolic link"
                ln -fs "/mnt/us/python/bin/python2.7" "${var}"
            fi
        fi
    done
fi

otautils_update_progressbar

# Install Python 3 in the userstore (we don't setup any symlinks in PATH for now)
if [ -f "./PY3" ] ; then
    logmsg "I" "install" "" "unpacking python 3..."
    # Make sure our xzdec binary is executable first...
    chmod +x ./xzdec
    ./xzdec "${HACKNAME}3.tar.xz" | tar -xvf - -C /mnt/us/
    _RET=$?
    if [ ${_RET} -ne 0 ] ; then
        logmsg "C" "install" "code=${_RET}" "failed to update userstore with custom directory"
        return 1
    fi
fi

otautils_update_progressbar

# Generate Python 3 bytecode (standard lib)
if [ -f "./PY3" ] ; then
    logmsg "I" "install" "" "generating bytecode (std lib) ..."
    /mnt/us/python3/bin/python${PY3_VER} -m compileall -f -x 'bad_coding|badsyntax|site-packages|lib2to3/tests/data|test|tests' /mnt/us/python3/lib/python${PY3_VER}
    _RET=$?
    if [ ${_RET} -ne 0 ] ; then
        logmsg "C" "install" "code=${_RET}" "failed to generate python bytecode for the standard lib"
        return 1
    fi
fi

otautils_update_progressbar

# Generate Python bytecode (third-party modules)
if [ -f "./PY3" ] ; then
    logmsg "I" "install" "" "generating bytecode (3rd party) ..."
    /mnt/us/python3/bin/python${PY3_VER} -m compileall -f -x badsyntax /mnt/us/python3/lib/python${PY3_VER}/site-packages
    _RET=$?
    if [ ${_RET} -ne 0 ] ; then
        logmsg "C" "install" "code=${_RET}" "failed to generate python bytecode for third-party modules"
        return 1
    fi
fi

otautils_update_progressbar

# Symlinks setup...
if [ -f "./PY3" ] ; then
    logmsg "I" "install" "" "installing python 3 symlinks"
    LIST="/usr/bin/python3 /usr/bin/python${PY3_VER}"
    for var in ${LIST} ; do
        if [ -L "${var}" ] ; then
            logmsg "I" "install" "" "symbolic link ${var} -> $( readlink ${var} ) already exists, skipping..."
        else
            if [ -x "${var}" ] ; then
                logmsg "I" "install" "" "binary ${var} already exists, skipping..."
            else
                logmsg "I" "install" "" "creating ${var} symbolic link"
                ln -fs "/mnt/us/python3/bin/python${PY3_VER}" "${var}"
            fi
        fi
    done

    logmsg "I" "install" "" "installing httpie symlinks"
    LIST="http https"
    for var in ${LIST} ; do
        if [ -L "/usr/bin/${var}" ] ; then
            logmsg "I" "install" "" "symbolic link /usr/bin/${var} -> $( readlink "/usr/bin/${var}" ) already exists, skipping..."
        else
            if [ -x "/usr/bin/${var}" ] ; then
                logmsg "I" "install" "" "binary ${var} already exists, skipping..."
            else
                logmsg "I" "install" "" "creating ${var} symbolic link"
                ln -fs "/mnt/us/python3/bin/${var}" "/usr/bin/${var}"
            fi
        fi
    done
fi

otautils_update_progressbar

logmsg "I" "install" "" "installing VERSION tag"
if [ -f "./PY2" ] ; then
    cp -f "VERSION" "/mnt/us/python/VERSION"
fi
if [ -f "./PY3" ] ; then
    cp -f "VERSION" "/mnt/us/python3/VERSION"
fi

otautils_update_progressbar

logmsg "I" "install" "" "flush to storage device"
sync

otautils_update_progressbar

logmsg "I" "install" "" "cleaning up"
rm -f "VERSION" "${HACKNAME}.tar.xz" "${HACKNAME}3.tar.xz" "xzdec" "PY2" "PY3"

otautils_update_progressbar

logmsg "I" "install" "" "done"

otautils_update_progressbar

return 0
