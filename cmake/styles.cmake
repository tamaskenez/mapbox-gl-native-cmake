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
install(FILES ${style_files} DESTINATION ${MBGL_PRODUCT_DIR})
