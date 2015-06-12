add_library(http ${platform}/darwin/http_request_nsurl.mm)
target_include_directories(http PRIVATE
    ${Boost_INCLUDE_DIRS}
    ${PROJECT_SOURCE_DIR}/include
    ${PROJECT_SOURCE_DIR}/src)
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
