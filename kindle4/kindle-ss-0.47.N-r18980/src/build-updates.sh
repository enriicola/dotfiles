#!/bin/bash -e
#
# $Id: build-updates.sh 18180 2021-02-20 01:57:20Z NiLuJe $
#

HACKDIR="ScreenSavers"
HACKNAME="linkss"
PKGNAME="${HACKNAME##*link}"
PKGVER="0.47.N"

# Setup KindleTool packaging metadata flags to avoid cluttering the invocations
PKGREV="$(svnversion -c .. | awk '{print $NF}' FS=':' | tr -d 'P')"
KT_PM_FLAGS=( "-xPackageName=${HACKDIR}" "-xPackageVersion=${PKGVER}-r${PKGREV}" "-xPackageAuthor=NiLuJe" "-xPackageMaintainer=NiLuJe" "-X" )

# Do we have kindletool (https://github.com/NiLuJe/KindleTool) in $PATH?
if kindletool help &>/dev/null ; then
	USE_KINDLETOOL="true"
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

# Force use of the python tool
#USE_KINDLETOOL="false"

# Pickup our common stuff... We leave it in our staging wd so it ends up in the source package.
if [[ ! -d "../../Common" ]] ; then
	echo "The tree isn't checked out in full, missing the Common directory..."
	exit 1
fi
# LibOTAUtils
ln -f ../../Common/lib/libotautils ./libotautils
# XZ Utils
ln -f ../../Common/bin/xzdec ./xzdec
# LibKH
for common_lib in libkh ; do
	ln -f ../../Common/lib/${common_lib} ../src/${HACKNAME}/bin/${common_lib}
done
# USB Watchdog
for common_bin in usb-watchdog usb-watchdog-helper ; do
	ln -f ../../Common/bin/${common_bin} ../src/${HACKNAME}/bin/${common_bin}
done
# FBInk
ln -f ../../Common/bin/fbink ../src/${HACKNAME}/bin/fbink

## Go away if we don't have the MobiCover tree checked out...
if [[ ! -d "../../../Touch_Hacks/MobiCover" ]] ; then
	echo "Skipping ScreenSavers build, we're missing MobiCover (from the Touch_Hacks tree)"
	exit 1
fi

# Make sure we bundle our KindleUnpack version...
for mobicover_bin in kindleunpack.py mobi_uncompress.py path.py utf8_utils.py ; do
	ln -f ../../../Touch_Hacks/MobiCover/Python/${mobicover_bin} ../src/${HACKNAME}/bin/${mobicover_bin}
done
# And remove deprecated stuff...
rm -f ../src/${HACKNAME}/bin/mobi_unpack.py


# Archive custom directory
export XZ_DEFAULTS="-T 0"
${TAR_BIN} --hard-dereference --owner root --group root --exclude-vcs -cvJf ${HACKNAME}.tar.xz ../src/${HACKNAME} ../src/extensions

KINDLE_MODELS="k2 k2i dx dxi dxg k3g k3w k3gb"

# OTAv2 MRPI only packages or not?
if [[ "${NO_MRPI_ONLY_PACKAGES}" == "true" ]] ; then
	for model in ${KINDLE_MODELS} ; do
		# Prepare our files for this specific kindle model...
		ARCH=${PKGNAME}_${PKGVER}_${model}

		if [[ "$USE_KINDLETOOL" == "true" ]] ; then
			# Install
			kindletool create ota -d ${model} libotautils install.sh ${HACKNAME}-init ${HACKNAME}.tar.xz xzdec Update_${ARCH}_install.bin
			# Uninstall
			kindletool create ota -d ${model} libotautils uninstall.sh Update_${ARCH}_uninstall.bin
		else
			# Build install update
			./kindle_update_tool.py m --${model} --sign ${ARCH}_install libotautils install.sh ${HACKNAME}-init ${HACKNAME}.tar.xz xzdec

			# Build uninstall update
			./kindle_update_tool.py m --${model} --sign ${ARCH}_uninstall libotautils uninstall.sh
		fi
	done
else
	if [[ "$USE_KINDLETOOL" == "true" ]] ; then
		ARCH="${PKGNAME}_${PKGVER}_k2_dx_k3"
		# Install
		kindletool create ota2 "${KT_PM_FLAGS[@]}" -d legacy libotautils install.sh ${HACKNAME}-init ${HACKNAME}.tar.xz xzdec Update_${ARCH}_install.bin
		# Uninstall
		kindletool create ota2 "${KT_PM_FLAGS[@]}" -d legacy -d kindle4 libotautils uninstall.sh Update_${PKGNAME}_${PKGVER}_uninstall.bin
	fi
fi

# Remove custom directory archive
rm -f ${HACKNAME}.tar.xz

# K4
if [[ "$USE_KINDLETOOL" == "true" ]] ; then
	## Go away if we don't have the Touch_hacks tree checked out...
	if [[ ! -d "../../../Touch_Hacks" ]] ; then
		echo "Skipping K4 build, we don't have the proper binaries on hand (hint: check out the Touch_Hacks tree, too)"
	else
		# NOTE: This isn't particularly pretty, and we end up bundling only one version of the binaries in the zip files, but at least the .bin files end up with the correct set of binaries ;)
		# K4/K5 binaries...
		KINDLE_MODEL_BINARIES="bin/convert bin/mogrify bin/identify bin/inotifywait bin/shlock bin/sort lib/libz.so.1 lib/libpng16.so.16 lib/libharfbuzz.so.0 lib/libfreetype.so.6 lib/libturbojpeg.so.0 lib/libjpeg.so.62 lib/libMagickWand-6.Q8.so.7 lib/libMagickCore-6.Q8.so.7 bin/mobicover"

		# Archive custom directory
		${TAR_BIN} --hard-dereference --owner root --group root --exclude-vcs -cvf ${HACKNAME}.tar ../src/${HACKNAME} ../src/extensions
		# Delete K3 binaries
		for my_bin in ${KINDLE_MODEL_BINARIES} ; do
			${TAR_BIN} --delete -vf ${HACKNAME}.tar src/${HACKNAME}/${my_bin}
		done
		# Append K4 binaries
		for my_bin in ${KINDLE_MODEL_BINARIES} ; do
			${TAR_BIN} --hard-dereference --owner root --group root --transform "s,^Touch_Hacks/${HACKDIR}/,,S" --show-transformed-names -rvf ${HACKNAME}.tar ../../../Touch_Hacks/${HACKDIR}/src/${HACKNAME}/${my_bin}
		done
		# Do the same for FBInk
		${TAR_BIN} --delete -vf ${HACKNAME}.tar src/${HACKNAME}/bin/fbink
		${TAR_BIN} --hard-dereference --owner root --group root --transform "s,^Touch_Hacks/Common/,src/${HACKNAME}/,S" --show-transformed-names -rvf ${HACKNAME}.tar ../../../Touch_Hacks/Common/bin/fbink
		# xz it...
		xz ${HACKNAME}.tar

		# Speaking of, we need our own xzdec binary, too!
		ln -f ../../../Touch_Hacks/Common/bin/xzdec ./xzdec

		# Prepare our files for this specific kindle models...
		ARCH=${PKGNAME}_${PKGVER}_k4

		# Install
		kindletool create ota2 "${KT_PM_FLAGS[@]}" -d kindle4 libotautils install.sh ${HACKNAME}-init ${HACKNAME}.tar.xz xzdec Update_${ARCH}_install.bin
		# Uninstall has already been taken care of if we're building unified packages :).
		if [[ "${NO_MRPI_ONLY_PACKAGES}" == "true" ]] ; then
			# Uninstall
			kindletool create ota2 "${KT_PM_FLAGS[@]}" -d kindle4 libotautils uninstall.sh Update_${ARCH}_uninstall.bin
		fi

		# Remove custom directory archive
		rm -f ${HACKNAME}.tar.xz
	fi
fi

# Cleanup
rm -f xzdec

# Move our updates :)
mv -f *.bin ../
