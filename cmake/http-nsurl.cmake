find_package(Boost REQUIRED)

add_library(http ${platform}/darwin/http_request_nsurl.mm)

target_include_directories(http
    PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${PROJECT_SOURCE_DIR}/src
        ${Boost_INCLUDE_DIRS}
    )

target_link_libraries(http PRIVATE
    libuv ${Boost_LIBRARIES})

target_compile_definitions(http
    PRIVATE
        ${Boost_DEFINITIONS}
    PUBLIC
        -DMBGL_HTTP_NSURL
    )
# todo
    #'ldflags': [
    #  '-framework Foundation', # For NSURLRequest
    #  '<@(uv_ldflags)',
    #],
