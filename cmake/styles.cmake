# styles
# todo support macosx bundle
#    {
#      'target_name': 'bundle_styles', # use this only for targets that create an App bundle
#      'type': 'none',
#      'hard_dependency': 1,
#      'dependencies': [ 'touch_styles' ], # required for xcode http://openradar.appspot.com/7232149
#      'direct_dependent_settings': {
#        'mac_bundle_resources': [ '../styles/styles' ],
#      }
#    },
file(GLOB style_files ${PROJECT_SOURCE_DIR}/styles/styles/*)
install(FILES ${style_files} DESTINATION ${MBGL_PRODUCT_DIR}/styles)

set(byproducts "")
foreach(f ${style_files})
    get_filename_component(name "${f}" NAME)
    list(APPEND byproducts "$<TARGET_FILE_DIR:dummy-exe-in-mbgl-target-dir>/styles/${name}")
endforeach()

add_custom_target(copy_styles
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        ${PROJECT_SOURCE_DIR}/styles/styles
        $<TARGET_FILE_DIR:dummy-exe-in-mbgl-target-dir>/styles
    DEPENDS ${style_files}
    BYPRODUCTS ${byproducts}
    COMMENT "Copying ${PROJECT_SOURCE_DIR}/styles/styles"
    VERBATIM
    SOURCES ${style_files}
)

