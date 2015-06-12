find_package(CURL REQUIRED)
add_library(http
    ${platform}/default/http_request_curl.cpp)
target_include_directories(http PRIVATE
    ${CURL_INCLUDE_DIRS}
    ${Boost_INCLUDE_DIRS}
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/src)
target_link_libraries(http PRIVATE
    libuv ${CURL_LIBRARIES} ${Boost_LIBRARIES})
target_compile_definitions(http
    PRIVATE
        ${CURL_DEFINITIONS} ${Boost_DEFINITIONS}
    PUBLIC
        -DMBGL_HTTP_CURL
    )
if(host STREQUAL "android")
    # todo
    ## Android uses libzip and openssl to set CURL's CA bundle.
    #'cflags_cc': [ '<@(zip_cflags)', '<@(openssl_cflags)' ],
    #'ldflags': [ '<@(zip_ldflags)', ],
    #'libraries': [ '<@(zip_static_libs)', ],
endif()
