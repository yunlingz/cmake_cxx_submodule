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

# rpath handling
set(CMAKE_MACOSX_RPATH ON)
set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/lib")
if(APPLE)
  set(CMAKE_INSTALL_RPATH "@loader_path/../lib")
elseif(UNIX)
  set(CMAKE_INSTALL_RPATH "$ORIGIN/../lib")
endif()

function(add_inc)
  set(OPTIONS PVT)
  set(ONE_VALUE_ARGS TGT)
  cmake_parse_arguments(ADD_INC
    "${OPTIONS}" "${ONE_VALUE_ARGS}" "" ${ARGN})

  if(EXISTS ${PROJECT_SOURCE_DIR}/${ADD_INC_TGT})
    include_directories(${PROJECT_SOURCE_DIR}/${ADD_INC_TGT})
    if(NOT ADD_INC_PVT)
      install(DIRECTORY "${PROJECT_SOURCE_DIR}/${ADD_INC_TGT}/" # trailing '/' is significant
        DESTINATION include)
    endif()
  else()
    message(FATAL_ERROR "${PROJECT_SOURCE_DIR}/${ADD_INC_TGT} not exists.")
  endif()
endfunction()

# add library target
function(add_lib)
  set(OPTIONS PVT)
  set(ONE_VALUE_ARGS TGT)
  set(MULTI_VALUE_ARGS SRC DEP COMPILE_FLAGS LINK_FLAGS)
  cmake_parse_arguments(ADD_LIB
    "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

  foreach(SRC_FILE ${ADD_LIB_SRC})
    if(EXISTS ${PROJECT_SOURCE_DIR}/${SRC_FILE})
      list(APPEND SRC_LIST ${PROJECT_SOURCE_DIR}/${SRC_FILE})
    else()
      message(FATAL_ERROR "${PROJECT_SOURCE_DIR}/${SRC_FILE} not exists.")
    endif()
  endforeach()

  if(BUILD_SHARED_LIBS AND (NOT ADD_LIB_PVT))
    add_library(${ADD_LIB_TGT} SHARED ${SRC_LIST})
    set_target_properties(${ADD_LIB_TGT} PROPERTIES
      VERSION ${PROJECT_VERSION}
      SOVERSION ${PROJECT_VERSION_MAJOR})
  else()
    add_library(${ADD_LIB_TGT} STATIC ${SRC_LIST})
  endif()

  if(ADD_LIB_DEP)
    target_link_libraries(${ADD_LIB_TGT} ${ADD_LIB_DEP})
  endif()

  if(ADD_LIB_COMPILE_FLAGS)
    string(REPLACE ";" " " ADD_LIB_COMPILE_FLAGS "${ADD_LIB_COMPILE_FLAGS}")
    set_target_properties(${ADD_LIB_TGT} PROPERTIES
      COMPILE_FLAGS ${ADD_LIB_COMPILE_FLAGS})
  endif()

  if(ADD_LIB_LINK_FLAGS)
    string(REPLACE ";" " " ADD_LIB_LINK_FLAGS "${ADD_LIB_LINK_FLAGS}")
    set_target_properties(${ADD_LIB_TGT} PROPERTIES
      LINK_FLAGS ${ADD_LIB_LINK_FLAGS})
  endif()

  if(NOT ADD_LIB_PVT)
    install(TARGETS ${ADD_LIB_TGT} LIBRARY
      DESTINATION lib
      COMPONENT ${ADD_LIB_TGT})
  endif()

  # --- experiential auto pkg-config file generator ---
  # if(BUILD_SHARED_LIBS AND (NOT ADD_LIB_PVT))
  #   configure_file(${PROJECT_SOURCE_DIR}/cmake/libtemplate.pc.in
  #     lib${ADD_LIB_TGT}.pc @ONLY)
  #   install(FILES ${CMAKE_CURRENT_BINARY_DIR}/lib${ADD_LIB_TGT}.pc
  #     DESTINATION lib/pkgconfig)
  # endif()
endfunction()

# add executable target
function(add_bin)
  set(OPTIONS PVT)
  set(ONE_VALUE_ARGS TGT)
  set(MULTI_VALUE_ARGS SRC INC DEP COMPILE_FLAGS LINK_FLAGS)
  cmake_parse_arguments(ADD_BIN
    "${OPTIONS}" "${ONE_VALUE_ARGS}" "${MULTI_VALUE_ARGS}" ${ARGN})

  foreach(SRC_FILE ${ADD_BIN_SRC})
    if(EXISTS ${PROJECT_SOURCE_DIR}/${SRC_FILE})
      list(APPEND SRC_LIST ${PROJECT_SOURCE_DIR}/${SRC_FILE})
    else()
      message(FATAL_ERROR "${PROJECT_SOURCE_DIR}/${SRC_FILE} not exists.")
    endif()
  endforeach()

  add_executable(${ADD_BIN_TGT} ${SRC_LIST})

  if(ADD_BIN_DEP)
    target_link_libraries(${ADD_BIN_TGT} ${ADD_BIN_DEP})
  endif()

  if(ADD_BIN_COMPILE_FLAGS)
    string(REPLACE ";" " " ADD_BIN_COMPILE_FLAGS "${ADD_BIN_COMPILE_FLAGS}")
    set_target_properties(${ADD_BIN_TGT} PROPERTIES
      COMPILE_FLAGS ${ADD_BIN_COMPILE_FLAGS})
  endif()

  if(ADD_BIN_LINK_FLAGS)
    string(REPLACE ";" " " ADD_BIN_LINK_FLAGS "${ADD_BIN_LINK_FLAGS}")
    set_target_properties(${ADD_BIN_TGT} PROPERTIES
      LINK_FLAGS ${ADD_BIN_LINK_FLAGS})
  endif()

  if(NOT ADD_BIN_PVT)
    install(TARGETS ${ADD_BIN_TGT} RUNTIME
      DESTINATION bin
      COMPONENT ${ADD_BIN_TGT})
  endif()
endfunction()
