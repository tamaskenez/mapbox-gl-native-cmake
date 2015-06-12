cmake_minimum_required(VERSION 3.1)
project(mbgl)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# options
set(MBGL_PRODUCT_DIR "mapbox-gl-native" CACHE PATH "PRODUCT_DIR")

# prerequisites
find_package(Git REQUIRED)

find_package(OpenGL REQUIRED)

if(WIN32)
    find_package(GLEW REQUIRED)
    add_definitions(-DHAVE_GLEW
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
    add_library(libgen STATIC windows/libgen.c windows/libgen.h)
    target_include_directories(libgen PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/windows>)
endif()

add_subdirectory(cmake)
