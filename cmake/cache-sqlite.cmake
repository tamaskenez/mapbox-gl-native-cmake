find_package(sqlite3 REQUIRED)
find_package(ZLIB REQUIRED)

add_library(cache
        ${PROJECT_SOURCE_DIR}/platform/default/sqlite_cache.cpp
        ${PROJECT_SOURCE_DIR}/platform/default/sqlite3.hpp
        ${PROJECT_SOURCE_DIR}/platform/default/sqlite3.cpp)

target_include_directories(cache
    PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${PROJECT_SOURCE_DIR}/src
    )

target_link_libraries(cache PRIVATE libuv sqlite3 ZLIB::ZLIB)
