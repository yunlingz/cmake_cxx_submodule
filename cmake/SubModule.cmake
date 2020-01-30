# Copyright 2017-2019 chuling <meetchuling@outlook.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if(NOT BUILD_SHARED_LIBS)
  option(BUILD_SHARED_LIBS "Create shared libraries" ON)
endif()

if(NOT (PROJECT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR))
  message(WARNING "We do not encourage you to build ${PROJECT_NAME} as a subproject")
endif()

if(EXISTS ${PROJECT_SOURCE_DIR}/include)
  install(DIRECTORY ${PROJECT_SOURCE_DIR}/include
    DESTINATION ${CMAKE_INSTALL_PREFIX})
endif()

# rpath handling
set(CMAKE_MACOSX_RPATH ON)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
if(APPLE)
  set(CMAKE_INSTALL_RPATH "@loader_path/../lib")
elseif(UNIX)
  set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
endif()

# add library target
function(add_lib)
  set(OPTIONS INNER)
  set(ONE_VALUE_ARGS TARGET_NAME)
  set(MULTI_VALUE_ARGS LINK_TO COMPILE_FLAGS LINK_FLAGS)
  cmake_parse_arguments(ADD_LIB
    "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

  if(NOT ADD_LIB_INNER)
    aux_source_directory(${PROJECT_SOURCE_DIR}/lib/${ADD_LIB_TARGET_NAME} SRC_LIST)
  else()
    aux_source_directory(${PROJECT_SOURCE_DIR}/inner/lib/${ADD_LIB_TARGET_NAME} SRC_LIST)
  endif()

  if(BUILD_SHARED_LIBS AND (NOT ADD_LIB_INNER))
    add_library(${ADD_LIB_TARGET_NAME} SHARED ${SRC_LIST})
    set_target_properties(${ADD_LIB_TARGET_NAME} PROPERTIES
      VERSION ${PROJECT_VERSION}
      SOVERSION ${PROJECT_VERSION_MAJOR})
  else()
    add_library(${ADD_LIB_TARGET_NAME} STATIC ${SRC_LIST})
  endif()

  target_include_directories(${ADD_LIB_TARGET_NAME} PUBLIC
    ${PROJECT_SOURCE_DIR}/include)
  if(NOT ADD_LIB_INNER)
    target_include_directories(${ADD_LIB_TARGET_NAME} PRIVATE
      ${PROJECT_SOURCE_DIR}/inner/include)
  else()
    target_include_directories(${ADD_LIB_TARGET_NAME} PUBLIC
      ${PROJECT_SOURCE_DIR}/inner/include)
  endif()

  if(ADD_LIB_LINK_TO)
    target_link_libraries(${ADD_LIB_TARGET_NAME} ${ADD_LIB_LINK_TO})
  endif()

  if(ADD_LIB_COMPILE_FLAGS)
    string(REPLACE ";" " " ADD_LIB_COMPILE_FLAGS "${ADD_LIB_COMPILE_FLAGS}")
    set_target_properties(${ADD_LIB_TARGET_NAME} PROPERTIES
      COMPILE_FLAGS ${ADD_LIB_COMPILE_FLAGS})
  endif()

  if(ADD_LIB_LINK_FLAGS)
    string(REPLACE ";" " " ADD_LIB_LINK_FLAGS "${ADD_LIB_LINK_FLAGS}")
    set_target_properties(${ADD_LIB_TARGET_NAME} PROPERTIES
      LINK_FLAGS ${ADD_LIB_LINK_FLAGS})
  endif()

  if(NOT ADD_LIB_INNER)
    install(TARGETS ${ADD_LIB_TARGET_NAME} LIBRARY
      DESTINATION lib
      COMPONENT ${ADD_LIB_TARGET_NAME})
  endif()

  if(BUILD_SHARED_LIBS AND (NOT ADD_LIB_INNER))
    configure_file(${PROJECT_SOURCE_DIR}/cmake/libtemplate.pc.in
      lib${ADD_LIB_TARGET_NAME}.pc @ONLY)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/lib${ADD_LIB_TARGET_NAME}.pc
      DESTINATION lib/pkgconfig)
  endif()
endfunction()

# add executable target
function(add_bin)
  set(OPTIONS INNER)
  set(ONE_VALUE_ARGS TARGET_NAME)
  set(MULTI_VALUE_ARGS LINK_TO COMPILE_FLAGS LINK_FLAGS)
  cmake_parse_arguments(ADD_BIN
    "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

  if(NOT ADD_BIN_INNER)
    aux_source_directory(${PROJECT_SOURCE_DIR}/bin/${ADD_BIN_TARGET_NAME} SRC_LIST)
  else()
    aux_source_directory(${PROJECT_SOURCE_DIR}/inner/bin/${ADD_BIN_TARGET_NAME} SRC_LIST)
  endif()

  add_executable(${ADD_BIN_TARGET_NAME} ${SRC_LIST})

  target_include_directories(${ADD_BIN_TARGET_NAME} PUBLIC
    ${PROJECT_SOURCE_DIR}/include)
  if(NOT ADD_BIN_INNER)
    target_include_directories(${ADD_BIN_TARGET_NAME} PRIVATE
      ${PROJECT_SOURCE_DIR}/inner/include)
  else()
    target_include_directories(${ADD_BIN_TARGET_NAME} PUBLIC
      ${PROJECT_SOURCE_DIR}/inner/include)
  endif()

  if(ADD_BIN_LINK_TO)
    target_link_libraries(${ADD_BIN_TARGET_NAME} ${ADD_BIN_LINK_TO})
  endif()

  if(ADD_BIN_COMPILE_FLAGS)
    string(REPLACE ";" " " ADD_BIN_COMPILE_FLAGS "${ADD_BIN_COMPILE_FLAGS}")
    set_target_properties(${ADD_BIN_TARGET_NAME} PROPERTIES
      COMPILE_FLAGS ${ADD_BIN_COMPILE_FLAGS})
  endif()

  if(ADD_BIN_LINK_FLAGS)
    string(REPLACE ";" " " ADD_BIN_LINK_FLAGS "${ADD_BIN_LINK_FLAGS}")
    set_target_properties(${ADD_BIN_TARGET_NAME} PROPERTIES
      LINK_FLAGS ${ADD_BIN_LINK_FLAGS})
  endif()

  if(NOT ADD_BIN_INNER)
    install(TARGETS ${ADD_BIN_TARGET_NAME} RUNTIME
      DESTINATION bin
      COMPONENT ${ADD_BIN_TARGET_NAME})
  endif()
endfunction()
