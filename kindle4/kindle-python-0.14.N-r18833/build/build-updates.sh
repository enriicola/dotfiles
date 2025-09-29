#!/bin/bash -e
#
# $Id: build-updates.sh 17455 2020-06-04 17:14:19Z NiLuJe $
#

HACKNAME="python"
HACKDIR="Python"
PKGNAME="${HACKNAME}"
PKGVER="0.14.N"

# Setup KindleTool packaging metadata flags to avoid cluttering the invocations
PKGREV="$(svnversion -c .. | awk '{print $NF}' FS=':' | tr -d 'P')"
KT_PM_FLAGS=( "-xPackageName=${HACKDIR}" "-xPackageVersion=${PKGVER}-r${PKGREV}" "-xPackageAuthor=NiLuJe" "-xPackageMaintainer=NiLuJe" "-X" )

# We need kindletool (https://github.com/NiLuJe/KindleTool) in $PATH
if (( $(kindletool version | wc -l) == 1 )) ; then
	HAS_KINDLETOOL="true"
fi

if [[ "${HAS_KINDLETOOL}" != "true" ]] ; then
	echo "You need KindleTool (https://github.com/NiLuJe/KindleTool) to build this package."
	exit 1
fi

# We also need GNU tar
if [[ "$(uname -s)" == "Darwin" ]] ; then
	TAR_BIN="gtar"
else
	TAR_BIN="tar"
fi
if ! ${TAR_BIN} --version | grep -q "GNU tar" ; then
	echo "You need GNU tar to build this package."
	exit 1
fi

# Pickup our common stuff... We leave it in our staging wd so it ends up in the source package.
if [[ ! -d "../../Common" ]] ; then
        echo "The tree isn't checked out in full, missing the Common directory..."
        exit 1
fi
# LibOTAUtils
ln -f ../../Common/lib/libotautils ./libotautils
# XZ Utils
ln -f ../../Common/bin/xzdec ./xzdec

# Copy the script to our working directory, to avoid storing crappy paths in the update package
ln -f ../src/install.sh ./
ln -f ../src/uninstall.sh ./
ln -f ../src/${HACKNAME}.tar.xz ./
ln -f ../src/${HACKNAME}3.tar.xz ./
ln -f ../VERSION ./
# This is how we discriminate split Python packages
touch ./PY2 ./PY3

KINDLE_MODELS="k2 k2i dx dxi dxg k3g k3w k3gb"

## Legacy
# OTAv2 MRPI only packages or not?
if [[ "${NO_MRPI_ONLY_PACKAGES}" == "true" ]] ; then
	for model in ${KINDLE_MODELS} ; do
		# Prepare our files for this specific kindle model...
		ARCH=${PKGNAME}_${PKGVER}_${model}

		# Uninstall
		kindletool create ota -d ${model} libotautils uninstall.sh Update_${ARCH}_uninstall.bin
		# Install
		kindletool create ota -d ${model} libotautils install.sh ${HACKNAME}.tar.xz PY2 xzdec VERSION Update_${ARCH}_install.bin
		ARCH=${PKGNAME}3_${PKGVER}_${model}
		kindletool create ota -d ${model} libotautils install.sh ${HACKNAME}3.tar.xz PY3 xzdec VERSION Update_${ARCH}_install.bin
	done
else
	ARCH="${PKGNAME}_${PKGVER}_k2_dx_k3"
	# Uninstall
	kindletool create ota2 "${KT_PM_FLAGS[@]}" -d legacy -d kindle4 libotautils uninstall.sh Update_${PKGNAME}_${PKGVER}_uninstall.bin
	# Install
	kindletool create ota2 "${KT_PM_FLAGS[@]}" -d legacy libotautils install.sh ${HACKNAME}.tar.xz PY2 xzdec VERSION Update_${ARCH}_install.bin
	ARCH="${PKGNAME}3_${PKGVER}_k2_dx_k3"
	kindletool create ota2 "${KT_PM_FLAGS[@]}" -d legacy libotautils install.sh ${HACKNAME}3.tar.xz PY3 xzdec VERSION Update_${ARCH}_install.bin
fi

# K4
if [[ ! -d "../../../Touch_Hacks" ]] ; then
	echo "Skipping K4 build, we don't have the proper binaries on hand (hint: check out the Touch_Hacks tree, too)"
else
	# Use the correct binaries for the K4...
	ln -f ../../../Touch_Hacks/Python/src/${HACKNAME}.tar.xz ${HACKNAME}.tar.xz
	ln -f ../../../Touch_Hacks/Python/src/${HACKNAME}3.tar.xz ${HACKNAME}3.tar.xz

	# Speaking of, we need our own xzdec binary, too!
	ln -f ../../../Touch_Hacks/Common/bin/xzdec ./xzdec

	# Install
	kindletool create ota2 "${KT_PM_FLAGS[@]}" -d kindle4 libotautils install.sh ${HACKNAME}.tar.xz PY2 xzdec VERSION Update_${PKGNAME}_${PKGVER}_k4_install.bin
	kindletool create ota2 "${KT_PM_FLAGS[@]}" -d kindle4 libotautils install.sh ${HACKNAME}3.tar.xz PY3 xzdec VERSION Update_${PKGNAME}3_${PKGVER}_k4_install.bin
	# Uninstall has already been taken care of if we're building unified packages :).
	if [[ "${NO_MRPI_ONLY_PACKAGES}" == "true" ]] ; then
		# Uninstall
		kindletool create ota2 "${KT_PM_FLAGS[@]}" -d kindle4 libotautils uninstall.sh Update_${PKGNAME}_${PKGVER}_k4_uninstall.bin
	fi
fi

## Cleanup
# Remove package specific temp stuff
rm -f ./install.sh ./uninstall.sh ./${HACKNAME}.tar.xz ./PY2 ./${HACKNAME}3.tar.xz ./PY3 ./xzdec ./VERSION

# Move our updates
mv -f *.bin ../
