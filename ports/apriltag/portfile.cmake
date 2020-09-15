

include(vcpkg_common_functions)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO tgRobotics/apriltag
    REF master
    SHA512 9ed37a6e9b9d84324a3dcb0e7aca81d76e821d48b75c691845fa49a91a4c6134590078c8d3db03051ce04360bb0228ac46d3f34aafb6ac17ea3a738f411ba7d2
    HEAD_REF master
    PATCHES
      "arm-opt.patch"
)

set(VCPKG_C_FLAGS "${VCPKG_C_FLAGS} /wd4244 /wd4005 /wd4018 /wd4267 -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE")
set(VCPKG_CXX_FLAGS "${VCPKG_CXX_FLAGS} /wd4244 /wd4005 /wd4018 /wd4267 -D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE")

if (VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore") # UWP:
vcpkg_replace_string(${SOURCE_PATH}/common/time_util.h
    "inline int gettimeofday(struct timeval* tp, void* tzp)" 
    "typedef struct timeval { long tv_sec; long tv_usec; } TIMEVAL;\r\n inline int gettimeofday(struct timeval* tp, void* tzzp)"
)
endif()

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=TRUE
        -DBUILD_APRIL_TAG_EXAMPLES=NO
        -DUSE_APRIL_TAGS_PYTHON_WRAPPER=NO
)

if (TRIPLET_SYSTEM_ARCH STREQUAL "arm64" OR TRIPLET_SYSTEM_ARCH STREQUAL "arm")
message("Patching ${SOURCE_PATH}/CMakeLists.txt")
vcpkg_replace_string(${SOURCE_PATH}/CMakeLists.txt
    "set(CMAKE_BUILD_TYPE Release)" 
    "set(CMAKE_BUILD_TYPE  Release)\r\n STRING(REPLACE \"/O2\" \"/Od\" CMAKE_C_FLAGS_RELEASE \${CMAKE_C_FLAGS_RELEASE})\r\n STRING(REPLACE \"/O2\" \"/Od\" CMAKE_CXX_FLAGS_RELEASE \${CMAKE_CXX_FLAGS_RELEASE})\r\nSTRING(REPLACE \"/Oi\" \"\" CMAKE_C_FLAGS_RELEASE \${CMAKE_C_FLAGS_RELEASE})\r\n STRING(REPLACE \"/Oi\" \"\" CMAKE_CXX_FLAGS_RELEASE \${CMAKE_CXX_FLAGS_RELEASE})\r\nmessage(\"Result = \${CMAKE_C_FLAGS_RELEASE}\")"
)
vcpkg_replace_string(${SOURCE_PATH}/CMakeLists.txt
    "set_source_files_properties(SOURCE \${TAG_FILES} PROPERTIES COMPILE_FLAGS -O0)" 
    ""
)
endif()

vcpkg_install_cmake()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

configure_file("${SOURCE_PATH}/LICENSE.md" "${CURRENT_PACKAGES_DIR}/share/apriltag/copyright" COPYONLY)

file(GLOB HEADER_FILES LIST_DIRECTORIES false "${SOURCE_PATH}/*.h")
file(INSTALL
    ${HEADER_FILES}
    DESTINATION ${CURRENT_PACKAGES_DIR}/include/apriltag
)
vcpkg_copy_pdbs()
