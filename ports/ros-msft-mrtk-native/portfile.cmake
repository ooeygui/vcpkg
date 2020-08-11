
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH 
    REPO ms-iot/ros_msft_mrtk_native
    REF master
    SHA512 d3d2849b39ce3c9f430ffc71a7f1d9ad3330d7fdffe6699416d6455eac3a04af8a2f18a30e089d00924cec7aa2c140dc26a30436ce72a100d419179ce50f361d
    HEAD_REF master
)

set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} /wd4244 /wd4005 /wd4018 /wd4267 -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE")
set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} /wd4244 /wd4005 /wd4018 /wd4267 -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE")

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE
)

vcpkg_install_cmake()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

configure_file("${SOURCE_PATH}/LICENSE.md" "${CURRENT_PACKAGES_DIR}/share/ros-msft-mrtk-native/copyright" COPYONLY)

file(GLOB HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/*.h")

file(INSTALL
    ${HEADER_FILES}
    DESTINATION ${CURRENT_PACKAGES_DIR}/include/ros-msft-mrtk-native
)
vcpkg_copy_pdbs()
