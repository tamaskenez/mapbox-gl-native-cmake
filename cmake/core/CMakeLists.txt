include(shaders.cmake)
include(version.cmake)

find_package(Boost REQUIRED thread)
add_definitions(-DBOOST_ALL_NO_LIB)

set(include ${PROJECT_SOURCE_DIR}/include)
set(src ${PROJECT_SOURCE_DIR}/src)

file(GLOB_RECURSE core_sources
	${src}/*.hpp ${src}/*.cpp ${src}/*.c ${src}/*.h
	${include}/*.hpp ${include}/*.h
	${src}/*.glsl)

add_library(core ${core_sources}
    # bin/style.json # todo where is this?
    )
set_target_properties(core PROPERTIES OUTPUT_NAME mbgl-core)
target_link_libraries(core PRIVATE shaders version libuv ${Boost_LIBRARIES} ${OPENGL_LIBRARIES})
target_include_directories(core
    PUBLIC ${include}
    PRIVATE ${src} ${Boost_INCLUDE_DIRS} ${OPENGL_INCLUDE_DIR})
target_compile_definitions(core PRIVATE ${Boost_DEFINITIONS})
if(GLEW_FOUND)
    target_compile_definitions(core PRIVATE GLEW::GLEW)
endif()
