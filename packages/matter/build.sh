TERMUX_PKG_HOMEPAGE=rangdong.com.vn
TERMUX_PKG_DESCRIPTION="Ralli HC"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_CONTINUE_BUILD=true

termux_step_configure() {
	echo "termux_step_configure start"
	if [ ! -d "$TERMUX_PKG_BUILDER_DIR/connectedhomeip" ]; then
		echo "git clone --recurse-submodules https://github.com/project-chip/connectedhomeip.git"
		git clone --recurse-submodules https://github.com/project-chip/connectedhomeip.git $TERMUX_PKG_BUILDER_DIR/connectedhomeip
	fi
	if [ ! -d "$TERMUX_PKG_BUILDDIR/connectedhomeip" ]; then
		cp -a $TERMUX_PKG_BUILDER_DIR/connectedhomeip $TERMUX_PKG_BUILDDIR
	fi
	echo "termux_step_configure end"
}

termux_step_make() {
	echo "termux_step_make start"
	cd connectedhomeip/examples/lighting-app/linux
	pwd
	# source third_party/connectedhomeip/scripts/activate.sh
	termux_setup_gn
	termux_setup_ninja
	echo "gn gen out/debug start"
	gn gen out/debug
	# gn gen out/debug --args='is_clang=true'
	# gn gen out/debug --args='is_clang=true target_cpu="arm"'
	# gn gen out/debug --args='is_clang=true target_cpu="arm" target_os="linux"'
	echo "ninja -C out/debug start"
	ninja -C out/debug
}
