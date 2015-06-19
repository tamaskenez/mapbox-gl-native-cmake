# certificates
set(src_cert_path ${PROJECT_SOURCE_DIR}/common/ca-bundle.crt)
get_filename_component(cert_filename "${src_cert_path}" NAME)

install(FILES ${cert_file} DESTINATION ${MBGL_PRODUCT_DIR})

set(dest_cert_dir $<TARGET_FILE_DIR:dummy-exe-in-mbgl-target-dir>)

add_custom_target(copy_certificate_bundle
    COMMAND ${CMAKE_COMMAND} -E copy ${src_cert_path} ${dest_cert_dir}
    DEPENDS ${src_cert_path}
    BYPRODUCTS ${dest_cert_dir}/${cert_filename}
    COMMENT "Copying ${src_cert_path}"
    VERBATIM
    SOURCES ${src_cert_path}
)
