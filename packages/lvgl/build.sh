TERMUX_PKG_HOMEPAGE=rangdong.com.vn
TERMUX_PKG_DESCRIPTION="Ralli Android HC small sceen"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_VERSION=2.0.0
TERMUX_PKG_DEPENDS="mosquitto, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cp -a $TERMUX_PKG_BUILDER_DIR/src $TERMUX_PKG_BUILDDIR
	export INCLUDES=-I$TERMUX_PREFIX/include
}

termux_step_make() {
	cd src
	make
}

termux_step_make_install() {
	install -Dm755 src/demo_s8 $TERMUX_PREFIX/bin
}
