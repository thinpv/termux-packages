TERMUX_PKG_HOMEPAGE=rangdong.com.vn
TERMUX_PKG_DESCRIPTION="Ralli HC"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_DEPENDS="mosquitto, libsqlite"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cp -a $TERMUX_PKG_BUILDER_DIR/smh_HC $TERMUX_PKG_BUILDDIR

	export INCLUDES=-I$TERMUX_PREFIX/include
}

termux_step_make() {
	cd smh_HC
	pwd
	make -f Makefile.android
}

termux_step_make_install() {
	pwd
	install -Dm755 smh_HC/smh $TERMUX_PREFIX/bin
}
