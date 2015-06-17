add_subdirectory(core)
add_subdirectory(platform)

set(platform ${PROJECT_SOURCE_DIR}/platform)
set(iplatform ${PROJECT_SOURCE_DIR}/include/mbgl/platform)

if(host STREQUAL "linux")
    set(sources
        ${PROJECT_SOURCE_DIR}/linux/main.cpp
        ${platform}/default/settings_json.cpp
        ${iplatform}/default/glfw_view.hpp
        ${platform}/default/glfw_view.cpp
        ${platform}/default/log_stderr.cpp
        ${platform}/default/default_styles.hpp
        ${platform}/default/default_styles.cpp
        )
endif()
if(host STREQUAL "windows")
    set(sources
        ${PROJECT_SOURCE_DIR}/linux/main.cpp
        ${platform}/default/settings_json.cpp
        ${iplatform}/default/glfw_view.hpp
        ${platform}/default/glfw_view.cpp
        ${platform}/default/log_stderr.cpp
        ${platform}/default/default_styles.hpp
        ${platform}/default/default_styles.cpp
        )
endif()

if(http_lib STREQUAL "curl")
    include(http-curl.cmake)
endif()

if(host STREQUAL "osx" OR host STREQUAL "ios")
    include(http-nsurl.cmake)
endif()

include(asset-${asset_lib}.cmake)
include(cache-${cache_lib}.cmake)


if(host STREQUAL "android")
    add_library(android-lib ${sources})
    set(t android-lib)
else()
    add_executable(app ${sources})
    set(t app)
endif()

target_link_libraries(${t} core platform http asset cache)

if(host MATCHES "^(linux|windows|macosx)$")
    find_package(glfw3 REQUIRED)
    target_link_libraries(${t} glfw)
endif()

#linux
#
#linux
#      'dependencies': [
#        '../mbgl.gyp:copy_styles',
#        '../mbgl.gyp:copy_certificate_bundle',
#      ],
#
#ios      'dependencies': [
#        '../mbgl.gyp:bundle_styles',
#      ],
#
#macosx
#     'dependencies': [
#        '../mbgl.gyp:bundle_styles',
#      ],
#
#android-lib       'dependencies': [
#      ],
#
#
#
#
#linuxapp:
#
#      'variables' : {
#        'cflags_cc': [
#          '<@(glfw3_cflags)',
#        ],
#        'ldflags': [
#          '<@(glfw3_ldflags)',
#        ],
#        'libraries': [
#          '<@(glfw3_static_libs)',
#        ],
#      },
#
#      'conditions': [
#        ['OS == "mac"', {
#          'libraries': [ '<@(libraries)' ],
#          'xcode_settings': {
#            'SDKROOT': 'macosx',
#            'SUPPORTED_PLATFORMS':'macosx',
#            'OTHER_CPLUSPLUSFLAGS': [ '<@(cflags_cc)' ],
#            'OTHER_LDFLAGS': [ '<@(ldflags)' ],
#            'SDKROOT': 'macosx',
#            'MACOSX_DEPLOYMENT_TARGET': '10.9',
#          }
#        }, {
#          'cflags_cc': [ '<@(cflags_cc)' ],
#          'libraries': [ '<@(libraries)', '<@(ldflags)' ],
#        }]
#      ],
#    },
#  ],
#}
#
#
#ios
#{
#  'includes': [
#    '../../gyp/common.gypi',
#  ],
#  'targets': [
#    { 'target_name': 'iosapp',
#      'product_name': 'Mapbox GL',
#      'type': 'executable',
#      'product_extension': 'app',
#      'mac_bundle': 1,
#      'mac_bundle_resources': [
#        '<!@(find ../ios/app/img -type f)',
#        './features.geojson',
#        './Settings.bundle/'
#      ],
#
#      'sources': [
#        './main.m',
#        './MBXAppDelegate.h',
#        './MBXAppDelegate.m',
#        './MBXViewController.h',
#        './MBXViewController.mm',
#        './MBXAnnotation.h',
#        './MBXAnnotation.m',
#        '../../platform/darwin/settings_nsuserdefaults.mm',
#      ],
#
#      'xcode_settings': {
#        'SDKROOT': 'iphoneos',
#        'SUPPORTED_PLATFORMS': 'iphonesimulator iphoneos',
#        'IPHONEOS_DEPLOYMENT_TARGET': '7.0',
#        'INFOPLIST_FILE': '../ios/app/app-info.plist',
#        'TARGETED_DEVICE_FAMILY': '1,2',
#        'COMBINE_HIDPI_IMAGES': 'NO', # don't merge @2x.png images into .tiff files
#        'CLANG_ENABLE_OBJC_ARC': 'YES',
#        'CLANG_ENABLE_MODULES': 'YES',
#      },
#
#      'configurations': {
#        'Debug': {
#          'xcode_settings': {
#            'CODE_SIGN_IDENTITY': 'iPhone Developer',
#          },
#        },
#        'Release': {
#          'xcode_settings': {
#            'CODE_SIGN_IDENTITY': 'iPhone Distribution',
#            'ARCHS': [ "armv7", "armv7s", "arm64", "i386", "x86_64" ],
#          },
#        },
#      },
#    }
#  ]
#}
#
#
#macosx
#{
#  'includes': [
#    '../gyp/common.gypi',
#  ],
#  'targets': [
#    { 'target_name': 'osxapp',
#      'product_name': 'Mapbox GL',
#      'type': 'executable',
#      'product_extension': 'app',
#      'mac_bundle': 1,
#      'mac_bundle_resources': [
#        'Icon.icns'
#      ],
#
# 
#
#      'sources': [
#        './main.mm',
#        '../platform/darwin/settings_nsuserdefaults.hpp',
#        '../platform/darwin/settings_nsuserdefaults.mm',
#        '../platform/darwin/reachability.m',
#        '../platform/default/glfw_view.hpp',
#        '../platform/default/glfw_view.cpp',
#        '../platform/default/default_styles.hpp',
#        '../platform/default/default_styles.cpp',
#      ],
#
#      'variables' : {
#        'cflags_cc': [
#          '<@(glfw3_cflags)',
#        ],
#        'ldflags': [
#          '-framework SystemConfiguration', # For NSUserDefaults and Reachability
#          '<@(glfw3_ldflags)',
#        ],
#        'libraries': [
#          '<@(glfw3_static_libs)',
#        ],
#      },
#
#      'libraries': [
#        '<@(libraries)',
#      ],
#
#      'xcode_settings': {
#        'SDKROOT': 'macosx',
#        'SUPPORTED_PLATFORMS':'macosx',
#        'OTHER_CPLUSPLUSFLAGS': [ '<@(cflags_cc)' ],
#        'OTHER_LDFLAGS': [ '<@(ldflags)' ],
#        'SDKROOT': 'macosx',
#        'INFOPLIST_FILE': '../macosx/Info.plist',
#        'CLANG_ENABLE_OBJC_ARC': 'YES'
#      },
#    }
#  ]
#}
#
#android 
#{
#  'includes': [
#    '../gyp/common.gypi',
#  ],
#  'targets': [
#    { 'target_name': 'android-lib',
#      'product_name': 'mapbox-gl',
#      'type': 'shared_library',
#      'hard_dependency': 1,
#
#      'dependencies': [
#        '../mbgl.gyp:core',
#        '../mbgl.gyp:platform-<(platform_lib)',
#        '../mbgl.gyp:http-<(http_lib)',
#        '../mbgl.gyp:asset-<(asset_lib)',
#        '../mbgl.gyp:cache-<(cache_lib)',
#      ],
#
#      'sources': [
#        './cpp/native_map_view.cpp',
#        './cpp/jni.cpp',
#      ],
#
#      'cflags_cc': [
#        '<@(boost_cflags)',
#      ],
#      'libraries': [
#          '<@(openssl_static_libs)',
#          '<@(curl_static_libs)',
#          '<@(png_static_libs)',
#          '<@(jpeg_static_libs)',
#          '<@(sqlite3_static_libs)',
#          '<@(uv_static_libs)',
#          '<@(nu_static_libs)',
#          '<@(zip_static_libs)',
#      ],
#      'variables': {
#        'ldflags': [
#          '-llog',
#          '-landroid',
#          '-lEGL',
#          '-lGLESv2',
#          '-lstdc++',
#          '-latomic',
#          '<@(png_ldflags)',
#          '<@(jpeg_ldflags)',
#          '<@(sqlite3_ldflags)',
#          '<@(openssl_ldflags)',
#          '<@(curl_ldflags)',
#          '<@(zlib_ldflags)',
#          '<@(zip_ldflags)',
#        ],
#      },
#      'conditions': [
#        ['OS == "mac"', {
#          'xcode_settings': {
#            'OTHER_LDFLAGS': [ '<@(ldflags)' ],
#          }
#        }, {
#          'libraries': [ '<@(ldflags)' ],
#        }]
#      ],
#    },


    