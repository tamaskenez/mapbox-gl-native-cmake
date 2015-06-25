cmake_minimum_required(VERSION 3.1)
project(mbgl)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_DEBUG_POSTFIX _d)

# options
set(MBGL_PRODUCT_DIR "mapbox-gl-native" CACHE PATH "PRODUCT_DIR")

# prerequisites
find_package(Git REQUIRED)

find_package(OpenGL REQUIRED)

if(WIN32)
    find_package(GLEW REQUIRED CONFIG)
    add_definitions(-DHAVE_GLEW # needs to be investigated if -DHAVE_GLEW should be added to any INTERFACE
        -DNOMINMAX # don't define min, max in windows.h
        -D_USE_MATH_DEFINES # define math constants in math.h
        -DWIN32_LEAN_AND_MEAN -DVC_EXTRALEAN # leave out parts of win
        /wd4068 # disable warning: unknown pragma
        /wd4996 # disable deprecation warnings
    )
endif()

set(python_version 2 EXACT)
find_package(PythonInterp ${python_version} QUIET)
if(WIN32 AND NOT PYTHONINTERP_FOUND)
    # a second desperate hack to find python2x
    set(cmake_program_path_saved "${CMAKE_PROGRAM_PATH}")
    file(GLOB python_dirs c:/python2*)
    list(APPEND CMAKE_PROGRAM_PATH ${python_dirs})
    unset(PYTHON_EXECUTABLE CACHE)
    find_package(PythonInterp ${python_version} REQUIRED)
    list(REMOVE_AT CMAKE_PROGRAM_PATH -1)
else()
    find_package(PythonInterp ${python_version} REQUIRED)
endif()

if(MSVC)
    add_library(windows-libgen STATIC windows/libgen/libgen.c windows/libgen/libgen.h)
    target_include_directories(windows-libgen PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/windows/libgen>)
    add_library(windows-getopt STATIC windows/getopt/getopt.cpp windows/getopt/getopt.h)
    target_include_directories(windows-getopt PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/windows/getopt>)
endif()

add_subdirectory(cmake)
