# Install script for directory: /mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/linux

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/")
  
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio"
         RPATH "$ORIGIN/lib")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle" TYPE EXECUTABLE FILES "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/intermediates_do_not_run/collage_studio")
  if(EXISTS "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio"
         OLD_RPATH "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/plugins/desktop_drop:/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/linux/flutter/ephemeral:"
         NEW_RPATH "$ORIGIN/lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/collage_studio")
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/data/icudtl.dat")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/data" TYPE FILE FILES "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/linux/flutter/ephemeral/icudtl.dat")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/lib/libflutter_linux_gtk.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/lib" TYPE FILE FILES "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/linux/flutter/ephemeral/libflutter_linux_gtk.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/lib/libdesktop_drop_plugin.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/lib" TYPE FILE FILES "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/plugins/desktop_drop/libdesktop_drop_plugin.so")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/lib/")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/lib" TYPE DIRECTORY FILES "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/native_assets/linux/")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  
  file(REMOVE_RECURSE "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/data/flutter_assets")
  
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/data/flutter_assets")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  file(INSTALL DESTINATION "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/bundle/data" TYPE DIRECTORY FILES "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build//flutter_assets")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/flutter/cmake_install.cmake")
  include("/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/runner/cmake_install.cmake")
  include("/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/plugins/desktop_drop/cmake_install.cmake")
  include("/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/plugins/jni/cmake_install.cmake")

endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
if(CMAKE_INSTALL_COMPONENT)
  if(CMAKE_INSTALL_COMPONENT MATCHES "^[a-zA-Z0-9_.+-]+$")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
  else()
    string(MD5 CMAKE_INST_COMP_HASH "${CMAKE_INSTALL_COMPONENT}")
    set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INST_COMP_HASH}.txt")
    unset(CMAKE_INST_COMP_HASH)
  endif()
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/mnt/c486a0a5-4bf5-47c8-b47c-1c40bdb2041f/Projects/Software/Desktop Apps/Flutter/Collage-studio/build/linux/x64/debug/${CMAKE_INSTALL_MANIFEST}"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
