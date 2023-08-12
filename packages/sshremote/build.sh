TERMUX_PKG_HOMEPAGE=rangdong.com.vn
TERMUX_PKG_DESCRIPTION="SSH remote"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_DEPENDS="mosquitto"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cp -a $TERMUX_PKG_BUILDER_DIR/sshremote $TERMUX_PKG_BUILDDIR
	export INCLUDES=-I$TERMUX_PREFIX/include
}

termux_step_make() {
	cd sshremote
	make -f Makefile.android
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/sshremote
	install -Dm755 sshremote/sshremote $TERMUX_PREFIX/bin
	install -Dm644 sshremote/config.json $TERMUX_PREFIX/etc/sshremote
}
