TERMUX_PKG_HOMEPAGE=rangdong.com.vn
TERMUX_PKG_DESCRIPTION="Ralli HC"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_DEPENDS="glib, libc++, libcrypt, openssl, ndk-multilib"
TERMUX_PKG_BUILD_IN_SRC=true
# TERMUX_CONTINUE_BUILD=true

termux_step_configure() {
	echo "termux_step_configure start"
	if [ ! -d "$TERMUX_PKG_BUILDER_DIR/connectedhomeip" ]; then
		echo "git clone --recurse-submodules https://github.com/project-chip/connectedhomeip.git"
		git clone --recurse-submodules https://github.com/project-chip/connectedhomeip.git $TERMUX_PKG_BUILDER_DIR/connectedhomeip
	fi
	if [ ! -d "$TERMUX_PKG_BUILDDIR/connectedhomeip" ]; then
		# ln -s $TERMUX_PKG_BUILDER_DIR/connectedhomeip $TERMUX_PKG_BUILDDIR/connectedhomeip
		cp -a $TERMUX_PKG_BUILDER_DIR/connectedhomeip $TERMUX_PKG_BUILDDIR
	fi
	echo "termux_step_configure end"
}

termux_step_make() {
	echo "termux_step_make start"
	cd connectedhomeip/examples/lighting-app/linux
	pwd
	# cd /home/builder/.termux-build/matter/src/connectedhomeip/examples/lighting-app/linux
	# source third_party/connectedhomeip/scripts/activate.sh
	echo "CC: " $CC
	echo "CXX: " $CXX
	echo "CPP: " $CPP
	echo "LD: " $LD
	echo "CFLAGS: " $CFLAGS
	echo "CXXFLAGS: " $CXXFLAGS
	echo "CPPFLAGS: " $CPPFLAGS
	echo "LDFLAGS: " $LDFLAGS
	echo "PKG_CONFIG: " $PKG_CONFIG
	echo "AR: " $AR
	echo "RANLIB: " $RANLIB

	# export CC=$CC
	# export CXX=$CXX
	# export CPP=$CPP
	# export CFLAGS+=$CFLAGS
	# export CXXFLAGS+=$CXXFLAGS
	# export CPPFLAGS+=$CPPFLAGS

	echo "gn gen out/debug start"
	termux_setup_gn
	# gn gen out/debug
	# gn gen out/debug --args='is_clang=true'
	# gn gen out/debug --args='is_clang=true target_cpu="arm"'
	# gn gen out/debug --args='is_clang=true target_cpu="arm" target_os="linux"'
	gn gen out/debug --args='is_clang=true target_cpu="arm" sysroot="/home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot"'
	
	echo "ninja -C out/debug start"
	termux_setup_ninja
	ninja -C out/debug
}
