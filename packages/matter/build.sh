TERMUX_PKG_HOMEPAGE=https://github.com/project-chip/connectedhomeip
TERMUX_PKG_DESCRIPTION="Matter"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="CSA"
TERMUX_PKG_VERSION=SVE_23_03-rc2
TERMUX_PKG_SRCURL=git+https://github.com/project-chip/connectedhomeip
TERMUX_PKG_GIT_BRANCH=master
#TERMUX_PKG_SRCURL=https://github.com/project-chip/connectedhomeip/archive/refs/tags/SVE_23_03/rc2.tar.gz
#TERMUX_PKG_SHA256=290ecf1781aadd70ec837436bc25a1855f86beea752c3991dbf173bc475babf6
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_IN_SRC=true

# termux_step_post_get_source() {
# 	echo "termux_step_post_get_source start"
# 	git submodule update --init
# 	ls
# 	pwd
# 	echo "termux_step_post_get_source end"
# }

termux_step_pre_configure() {
	echo "termux_step_pre_configure start"
	source ./scripts/bootstrap.sh
	echo "termux_step_pre_configure end"
}

termux_step_configure() {
	echo "termux_step_configure start"
	pwd
	source scripts/activate.sh
	echo "termux_step_configure end"
}

termux_step_make() {
	echo "termux_step_make start"
	pwd
	termux_setup_gn
	gn gen out/host
	termux_setup_ninja
	ninja -C out/host
	echo "termux_step_make end"
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin out/gn
}
