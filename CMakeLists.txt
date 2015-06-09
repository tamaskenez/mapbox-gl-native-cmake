cmake_minimum_required(VERSION 3.0)
project(mbgl)

# options
set(PRODUCT_DIR "mapbox-gl-native" CACHE PATH "PRODUCT_DIR")

# prerequisites
find_package(Git REQUIRED)

find_package(PythonInterp 2 EXACT QUIET)
if(WIN32 AND NOT PYTHONINTERP_FOUND)
    # a second desperate hack to find python2x
    set(cmake_program_path_saved "${CMAKE_PROGRAM_PATH}")
    file(GLOB python_dirs c:/python2*)
    list(APPEND CMAKE_PROGRAM_PATH ${python_dirs})
    unset(PYTHON_EXECUTABLE CACHE)
    find_package(PythonInterp 2 EXACT REQUIRED)
    list(REMOVE_AT CMAKE_PROGRAM_PATH -1)
else()
    find_package(PythonInterp 2 EXACT REQUIRED)
endif()

find_package(libuv REQUIRED)

find_package(OpenGL REQUIRED)

find_package(Boost REQUIRED)
add_definitions(-DBOOST_ALL_NO_LIB)

# shaders
file(GLOB_RECURSE glsl_files src/*.glsl)
set(generated_shader_sources
    ${CMAKE_CURRENT_BINARY_DIR}/include/mbgl/shader/shaders.hpp
    ${CMAKE_CURRENT_BINARY_DIR}/src/shader/shaders_gl.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/src/shader/shaders_gles2.cpp
)

add_custom_command(
    COMMENT "Build Shaders"
    MAIN_DEPENDENCY scripts/build-shaders.py
    DEPENDS ${glsl_files}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND ${PYTHON_EXECUTABLE}
        scripts/build-shaders.py ${CMAKE_CURRENT_BINARY_DIR} ${glsl_files}
    OUTPUT ${generated_shader_sources}
    VERBATIM
)

add_library(shaders INTERFACE)
target_sources(shaders INTERFACE ${generated_shader_sources})
target_include_directories(shaders INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include)



# version
# Warning: this does not force reconfigure on new commit!
# It can be done, though, see http://stackoverflow.com/questions/1435953/how-can-i-pass-git-sha1-to-compiler-as-definition-using-cmake
execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags --always --abbrev=0
    OUTPUT_VARIABLE git_describe_out
    RESULT_VARIABLE r
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(r)
    message(FATAL_ERROR "git describe failed: ${r}")
endif()
execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    OUTPUT_VARIABLE git_revparse_out
    RESULT_VARIABLE r
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(r)
    message(FATAL_ERROR "git rev-parse failed: ${r}")
endif()

set(generated_version_source ${CMAKE_CURRENT_BINARY_DIR}/include/mbgl/util/version.hpp)
add_custom_command(
    COMMENT "Build Version Header"
    MAIN_DEPENDENCY scripts/build-version.py
    OUTPUT ${generated_version_source}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    COMMAND ${PYTHON_EXECUTABLE}
        scripts/build-version.py ${CMAKE_CURRENT_BINARY_DIR} ${git_describe_out} ${git_revparse_out}
    VERBATIM
)

add_library(version INTERFACE)
target_sources(version INTERFACE ${generated_version_source})
target_include_directories(version INTERFACE ${CMAKE_CURRENT_BINARY_DIR}/include)

# styles
# todo support macosx bundle
#    {
#      'target_name': 'bundle_styles', # use this only for targets that create an App bundle
#      'type': 'none',
#      'hard_dependency': 1,
#      'dependencies': [ 'touch_styles' ], # required for xcode http://openradar.appspot.com/7232149
#      'direct_dependent_settings': {
#        'mac_bundle_resources': [ '../styles/styles' ],
#      }
#    },
file(GLOB style_files styles/styles/*)
install(FILES ${style_files} DESTINATION ${PRODUCT_DIR})

# certificates
install(FILES common/ca-bundle.crt DESTINATION ${PRODUCT_DIR})

file(GLOB_RECURSE core_sources src/*.hpp src/*.cpp src/*.c src/*.h include/*.hpp include/*.h src/*.glsl)
add_library(core ${core_sources}
    # bin/style.json # todo where is this?
    )
set_target_properties(core PROPERTIES OUTPUT_NAME mbgl-core)
target_link_libraries(core PRIVATE shaders version libuv ${Boost_LIBRARIES} ${OPENGL_LIBRARIES})
target_include_directories(core
    PUBLIC include
    PRIVATE src ${Boost_INCLUDE_DIRS} ${OPENGL_INCLUDE_DIR})
target_compile_definitions(core PRIVATE ${Boost_DEFINITIONS})

# standalone
#{
#  'targets': [
#    { 'target_name': 'everything',
#      'type': 'none',
#      'hard_dependency': 1,
#
#      'dependencies': [
#        'core',
#        'platform-<(platform_lib)',
#        'http-<(http_lib)',
#        'asset-<(asset_lib)',
#        'cache-<(cache_lib)',
#        'headless-<(headless_lib)',
#      ],
#    },
#
#    { 'target_name': 'standalone',
#      'product_name': 'libmbgl.a',
#      'type': 'executable',
#      'hard_dependency': 1,
#
#      'dependencies': [
#        'core',
#        'platform-<(platform_lib)',
#        'http-<(http_lib)',
#        'asset-<(asset_lib)',
#        'cache-<(cache_lib)',
#        'headless-<(headless_lib)',
#      ],
#    },
#  ],
#}




