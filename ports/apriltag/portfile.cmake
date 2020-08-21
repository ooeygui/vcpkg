

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tgRobotics/apriltag
    REF master
    SHA512 9ed37a6e9b9d84324a3dcb0e7aca81d76e821d48b75c691845fa49a91a4c6134590078c8d3db03051ce04360bb0228ac46d3f34aafb6ac17ea3a738f411ba7d2
    HEAD_REF master
)

set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} /wd4244 /wd4005 /wd4018 /wd4267 -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE")
set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} /wd4244 /wd4005 /wd4018 /wd4267 -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE")

if (VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore") # UWP:
vcpkg_replace_string(${SOURCE_PATH}/common/time_util.h
    "inline int gettimeofday(struct timeval* tp, void* tzp)" 
    "typedef struct timeval { long tv_sec; long tv_usec; } TIMEVAL;\r\n inline int gettimeofday(struct timeval* tp, void* tzp)"
)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE
)

vcpkg_fixup_cmake_targets()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

configure_file("${SOURCE_PATH}/LICENSE.md" "${CURRENT_PACKAGES_DIR}/share/apriltag/copyright" COPYONLY)

file(GLOB HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/*.h")
file(INSTALL
    ${HEADER_FILES}
    DESTINATION ${CURRENT_PACKAGES_DIR}/include/apriltag
)
vcpkg_copy_pdbs()

if (VCPKG_TARGET_IS_UWP AND TRIPLET_SYSTEM_ARCH STREQUAL "arm64") # UWP:
vcpkg_copy_tools(
    TOOL_NAMES 
        apriltag_demo
    AUTO_CLEAN
)

else()

vcpkg_copy_tools(
    TOOL_NAMES 
        apriltag_demo
        opencv_demo
    AUTO_CLEAN
)
endif()