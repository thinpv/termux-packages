TERMUX_PKG_HOMEPAGE=git://git.openwrt.org/project/libubox.git
TERMUX_PKG_DESCRIPTION="C utility functions for OpenWrt"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="Openwrt"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_SRCURL=git+git://git.openwrt.org/project/libubox.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="liblua51, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	echo "termux_step_post_get_source start"
	ls
	pwd
	git fetch --unshallow
	ls
	pwd
	echo "termux_step_post_get_source end"
}

termux_step_configure() {
	echo "termux_step_configure start"
	pwd
	termux_setup_cmake
	cmake
	echo "termux_step_configure end"
}

termux_step_make() {
	echo "termux_step_make start"
	pwd
	termux_setup_cmake
	cmake "$TERMUX_PKG_SRCDIR"
	make -j $TERMUX_MAKE_PROCESSES
	echo "termux_step_make end"
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin out/gn
}
