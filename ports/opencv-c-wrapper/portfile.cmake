
include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH 
    REPO Camelron/opencv-c-wrapper
    REF master
    SHA512 f141b1c686bedc2df8de9dabae3e49c25f829cd47661d86db3af04f48e9aa7401e10ea7ad42e5413e810a3e7065a59607a0f5f41c8e656e18d88aa2849fd9faf
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

configure_file("${SOURCE_PATH}/LICENSE.md" "${CURRENT_PACKAGES_DIR}/share/opencv-c-wrapper/copyright" COPYONLY)

file(GLOB HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/*.h")

file(INSTALL
    ${HEADER_FILES}
    DESTINATION ${CURRENT_PACKAGES_DIR}/include/opencv-c-wrapper
)
vcpkg_copy_pdbs()
