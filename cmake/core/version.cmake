# version
# Warning: this does not force reconfigure on new commit!
# It could be done, though, see http://stackoverflow.com/questions/1435953/how-can-i-pass-git-sha1-to-compiler-as-definition-using-cmake
execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags --always --abbrev=0
    OUTPUT_VARIABLE git_describe_out
    RESULT_VARIABLE r
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(r)
    message(FATAL_ERROR "git describe failed: ${r}")
endif()

execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse HEAD
    OUTPUT_VARIABLE git_revparse_out
    RESULT_VARIABLE r
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    OUTPUT_STRIP_TRAILING_WHITESPACE)
if(r)
    message(FATAL_ERROR "git rev-parse failed: ${r}")
endif()

set(generated_version_source ${PROJECT_BINARY_DIR}/include/mbgl/util/version.hpp)
add_custom_command(
    COMMENT "Build Version Header"
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/scripts/build-version.py
    OUTPUT ${generated_version_source}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND ${PYTHON_EXECUTABLE}
        scripts/build-version.py ${PROJECT_BINARY_DIR} ${git_describe_out} ${git_revparse_out}
    VERBATIM
)

add_library(version INTERFACE)

target_sources(version INTERFACE ${generated_version_source})
target_include_directories(version INTERFACE $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)

