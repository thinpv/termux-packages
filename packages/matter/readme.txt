ln -s /system /home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot/system
ln -s /home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arm-linux-androideabi/asm/ /home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/asm

Thêm vào jsoncpp
config("jsoncpp_config") {
  include_dirs = [ 
    "repo/include",
    "/home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include",
    "/home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/c++/v1",
    "/home/builder/lib/android-ndk-r23c/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include/arm-linux-androideabi",
  ]
}

comment: VerifyOrReturnError(pthread_join(mChipEventCommandListener, nullptr) == 0, CHIP_ERROR_SHUT_DOWN);