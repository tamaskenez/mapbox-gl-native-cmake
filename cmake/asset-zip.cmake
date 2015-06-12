find_package(libzip REQUIRED)
add_library(asset
        ${PROJECT_SOURCE_DIR}/platform/default/asset_request_zip.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/uv_zip.c
        )
target_include_directories(asset
  PRIVATE
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/src
    ${Boost_INCLUDE_DIRS})

target_link_libraries(asset PRIVATE
  libuv ZLIB::ZLIB libzip ${Boost_LIBRARIES})

target_compile_definitions(asset
  PUBLIC
    -DMBGL_ASSET_ZIP
  PRIVATE
    ${Boost_DEFINITIONS})
