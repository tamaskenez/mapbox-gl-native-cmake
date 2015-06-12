set(include ${PROJECT_BINARY_DIR}/include)
set(src ${PROJECT_SOURCE_DIR}/src)
set(bsrc ${PROJECT_BINARY_DIR}/src)

# shaders
file(GLOB_RECURSE glsl_files ${src}/*.glsl)
set(generated_shader_sources
    ${include}/mbgl/shader/shaders.hpp
    ${bsrc}/shader/shaders_gl.cpp
    ${bsrc}/shader/shaders_gles2.cpp
)

add_custom_command(
    COMMENT "Build Shaders"
    MAIN_DEPENDENCY ${PROJECT_SOURCE_DIR}/scripts/build-shaders.py
    DEPENDS ${glsl_files}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND ${PYTHON_EXECUTABLE}
        scripts/build-shaders.py ${PROJECT_BINARY_DIR} ${glsl_files}
    OUTPUT ${generated_shader_sources}
    VERBATIM
)

add_library(shaders INTERFACE)
target_sources(shaders INTERFACE ${generated_shader_sources})
target_include_directories(shaders INTERFACE $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/include>)

