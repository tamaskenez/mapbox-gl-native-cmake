
find_package(Boost REQUIRED)
add_definitions(-DBOOST_ALL_NO_LIB)

# compatibility with the CMake distro FindJPEG.cmake
if(NOT TARGET JPEG::JPEG)
  add_library(JPEG::JPEG UNKNOWN IMPORTED)
  set_target_properties(JPEG::JPEG PROPERTIES
    IMPORTED_LOCATION "${JPEG_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${JPEG_INCLUDE_DIR}")
endif()

set(platform ${PROJECT_SOURCE_DIR}/platform)
set(include ${PROJECT_SOURCE_DIR}/include)

if(platform_lib STREQUAL "osx" AND host STREQUAL "osx")
  set(sources
    ${platform}/darwin/log_nslog.mm
    ${platform}/darwin/string_nsstring.mm
    ${platform}/darwin/application_root.mm
    ${platform}/darwin/asset_root.mm
    ${platform}/darwin/image.mm
    ${platform}/darwin/nsthread.mm)
  set(deps libuv Boost)
  message(FATAL_ERROR "todo")
#        'ldflags': [
#          '-framework Foundation',
#          '-framework ImageIO',
#          '-framework CoreServices',
#          '-framework OpenGL',
#          '-framework ApplicationServices',
#        ],
  set(include_dirs PRIVATE ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src)
endif()
if(platform_lib STREQUAL "ios" AND host STREQUAL "ios")
  set(sources
    ${platform}/darwin/log_nslog.mm
    ${platform}/darwin/string_nsstring.mm
    ${platform}/darwin/application_root.mm
    ${platform}/darwin/asset_root.mm
    ${platform}/darwin/image.mm
    ${platform}/darwin/nsthread.mm
    ${platform}/darwin/reachability.m
    ${include}/mbgl/ios/MapboxGL.h
    ${platform}/ios/MGLMapboxEvents.h
    ${platform}/ios/MGLMapboxEvents.m
    ${include}/mbgl/ios/MGLMapView.h
    ${include}/mbgl/ios/MGLMapView+IBAdditions.h
    ${platform}/ios/MGLMapView.mm
    ${platform}/ios/MGLFileCache.h
    ${platform}/ios/MGLFileCache.mm
    ${include}/mbgl/ios/MGLAccountManager.h
    ${platform}/ios/MGLAccountManager_Private.h
    ${platform}/ios/MGLAccountManager.m
    ${include}/mbgl/ios/MGLAnnotation.h
    ${include}/mbgl/ios/MGLUserLocation.h
    ${platform}/ios/MGLUserLocation_Private.h
    ${platform}/ios/MGLUserLocation.m
    ${platform}/ios/MGLUserLocationAnnotationView.h
    ${platform}/ios/MGLUserLocationAnnotationView.m
    ${include}/mbgl/ios/MGLTypes.h
    ${platform}/ios/MGLTypes.m
    ${platform}/ios/NSBundle+MGLAdditions.h
    ${platform}/ios/NSBundle+MGLAdditions.m
    ${platform}/ios/NSException+MGLAdditions.h
    ${platform}/ios/NSProcessInfo+MGLAdditions.h
    ${platform}/ios/NSProcessInfo+MGLAdditions.m
    ${platform}/ios/NSString+MGLAdditions.h
    ${platform}/ios/NSString+MGLAdditions.m
    ${platform}/ios/vendor/SMCalloutView/SMCalloutView.h
    ${platform}/ios/vendor/SMCalloutView/SMCalloutView.m
    )
  set(deps libuv Boost)
  message(FATAL_ERROR "todo")
#        'ldflags': [
#          '-framework CoreLocation',
#          '-framework CoreTelephony',
#          '-framework GLKit',
#          '-framework ImageIO',
#          '-framework MobileCoreServices',
#          '-framework QuartzCore',
#          '-framework SystemConfiguration',
#          '-ObjC',
#        ],
  set(include_dirs PRIVATE ${PROJECT_SOURCE_DIR}/include)
endif()
if(platform_lib STREQUAL "linux")
  find_package(PNG REQUIRED)
  find_package(JPEG REQUIRED)
  find_package(nunicode REQUIRED)
  set(sources
        ${platform}/default/log_stderr.cpp
        ${platform}/default/string_stdlib.cpp
        ${platform}/default/application_root.cpp
        ${platform}/default/asset_root.cpp
        ${platform}/default/thread.cpp
        ${platform}/default/image.cpp
        ${platform}/default/image_reader.cpp
        ${platform}/default/png_reader.cpp
        ${platform}/default/jpeg_reader.cpp
    )
  set(deps PNG JPEG::JPEG libuv Boost nunicode::nu)
  set(include_dirs PRIVATE ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src)
endif()
if(platform_lib STREQUAL "android" AND host STREQUAL "android")
  find_package(PNG REQUIRED)
  find_package(JPEG REQUIRED)
  find_package(nunicode REQUIRED)
  set(sources
    ${platform}/android/log_android.cpp
    ${platform}/android/asset_root.cpp
    ${platform}/default/thread.cpp
    ${platform}/default/string_stdlib.cpp
    ${platform}/default/image.cpp
    ${platform}/default/image_reader.cpp
    ${platform}/default/png_reader.cpp
    ${platform}/default/jpeg_reader.cpp
    )
  set(deps PNG JPEG::JPEG libuv nunicode::nu Boost)
  set(include_dirs PRIVATE ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src)
endif()
if(platform_lib STREQUAL "windows" AND host STREQUAL "windows")
  find_package(PNG REQUIRED)
  find_package(JPEG REQUIRED)
  find_package(nunicode REQUIRED)
  set(sources
        ${platform}/default/log_stderr.cpp
        ${platform}/default/string_stdlib.cpp
        ${platform}/default/application_root.cpp
        ${platform}/default/asset_root.cpp
        ${platform}/default/thread.cpp
        ${platform}/default/image.cpp
        ${platform}/default/image_reader.cpp
        ${platform}/default/png_reader.cpp
        ${platform}/default/jpeg_reader.cpp
    )
  set(deps PNG JPEG::JPEG libuv Boost nunicode::nu)
  set(include_dirs PRIVATE ${PROJECT_SOURCE_DIR}/include ${PROJECT_SOURCE_DIR}/src)
endif()

add_library(platform ${sources})
set_target_properties(platform PROPERTIES OUTPUT_NAME mbgl-platform-${host})

target_include_directories(platform ${include_dirs})
foreach(i ${deps})
  if(TARGET "${i}")
    target_link_libraries(platform PRIVATE ${i})
  else()
    target_link_libraries(platform PRIVATE ${${i}_LIBRARIES})
    target_include_directories(platform PRIVATE ${${i}_INCLUDE_DIRS})
    target_compile_definitions(platform PRIVATE ${${i}_DEFINITIONS})
  endif()
endforeach()

target_include_directories(platform INTERFACE $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>)

if(host STREQUAL "windows")
  target_link_libraries(platform PRIVATE windows-libgen)
endif()

