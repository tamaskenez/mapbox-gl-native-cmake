set(CAKE_PKG_REGISTRIES ${CMAKE_CURRENT_LIST_DIR}/cmake/cake-package-urls.cmake)
set(CAKE_BINARY_DIR_PREFIX "${CMAKE_CURRENT_LIST_DIR}/.out/build")
set(CAKE_PKG_CLONE_DIR "${CMAKE_CURRENT_LIST_DIR}/.clone")

set(CMAKE_INSTALL_PREFIX "${CMAKE_CURRENT_LIST_DIR}/.out")
set(CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}")

# this is needed to hijack the find_package calls to find config modules first
list(APPEND CMAKE_ARGS "-DCMAKE_MODULE_PATH=${CMAKE_CURRENT_LIST_DIR}/cmake/hijack-modules")

# Optionally create your cake-project-local.cmake file in this directory
# and you can set the following variables:
#
# Your generator of choice (specify if you use other than the default one)
#
#     set(CMAKE_GENERATOR "Visual Studio 12 2013 Win64")
#
# Additional cmake args, for example, to find Boost
#
#     list(APPEND CMAKE_ARGS -DBOOST_LIBRARYDIR=c:/Users/tamas.kenez/lib64)
#
# Your optional shared package repository project for third-party dependencies:
#
#     set(CAKE_PKG_PROJECT_DIR "c:/Users/tamas.kenez/pkg_vs12_64")
#     list(APPEND CMAKE_PREFIX_PATH "${CAKE_PKG_PROJECT_DIR}/install")
