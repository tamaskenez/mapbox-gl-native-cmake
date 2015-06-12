The structure of the CMake files tries to mimic the how gyp files are organized
for easier maintenance

    CMakeLists.txt (root)
    -> cmake/CMakeLists.txt          (add_subdirectory)
       -- defaults.cmake             (include)
       -- mapboxgl-app.cmake         (include)
          -- shaders.cmake           (include)
          -- version.cmake           (include)
          -> core/CMakeLists.txt     (add_subdirectory)
          -> platform/CMakeLists.txt (add_subdirectory)


         