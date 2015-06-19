find_package(Boost REQUIRED)

add_library(asset
        ${PROJECT_SOURCE_DIR}/platform/default/asset_request_fs.cpp
        )
set_target_properties(asset PROPERTIES OUTPUT_NAME mbgl-asset-fs)
target_include_directories(asset
  PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
  PRIVATE
    ${PROJECT_SOURCE_DIR}/src
    ${Boost_INCLUDE_DIRS})

target_link_libraries(asset PRIVATE
  libuv ${Boost_LIBRARIES})

target_compile_definitions(asset
  PUBLIC
    -DMBGL_ASSET_FS
  PRIVATE
    ${Boost_DEFINITIONS})
