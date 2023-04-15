TERMUX_PKG_HOMEPAGE=rangdong.com.vn
TERMUX_PKG_DESCRIPTION="Ralli HC"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	echo "termux_step_configure start"
	cp -a $TERMUX_PKG_BUILDER_DIR/connectedhomeip $TERMUX_PKG_BUILDDIR
	echo "termux_step_configure end"
}

termux_step_make() {
	echo "termux_step_make start"
	cd connectedhomeip/examples/lighting-app/linux
	# source third_party/connectedhomeip/scripts/activate.sh
	termux_setup_gn
	termux_setup_ninja
	echo "gn gen out/debug start"
	gn gen out/debug
	echo "ninja -C out/debug start"
	ninja -C out/debug
}
