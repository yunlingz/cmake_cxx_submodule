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

string(TOLOWER "${CMAKE_BUILD_TYPE}" LOWERCASE_CMAKE_BUILD_TYPE)
if(LOWERCASE_CMAKE_BUILD_TYPE STREQUAL "debug")
  set(CMAKE_BUILD_TYPE "Debug")
  message(STATUS "Set build type to debug")
else()
  set(CMAKE_BUILD_TYPE "Release")
  message(STATUS "Set build type to release")
endif()

if(CMAKE_C_COMPILER_ID MATCHES "Clang|GNU")
  include(CheckCCompilerFlag)
  # basic gnu99 flags
  # -----------------------------------------------------------------
  # -std=gnu99 -Wall -Wextra
  # -Wmissing-prototypes -Wstrict-prototypes -Wvla
  # -----------------------------------------------------------------
  check_c_compiler_flag("-std=gnu99" C_COMPILER_HAS_GNU99_SUPPORT)
  if (C_COMPILER_HAS_GNU99_SUPPORT)
    list(APPEND CUSTOM_CMAKE_C_FLAGS "-std=gnu99")
  else()
    message(FATAL_ERROR "${CMAKE_C_COMPILER_ID} has no GNU99 support")
  endif()

  check_c_compiler_flag("-Wall" C_COMPILER_HAS_WALL)
  if(C_COMPILER_HAS_WALL)
    list(APPEND CUSTOM_CMAKE_C_FLAGS "-Wall")
  endif()

  check_c_compiler_flag("-Wextra" C_COMPILER_HAS_WEXTRA)
  if(C_COMPILER_HAS_WEXTRA)
    list(APPEND CUSTOM_CMAKE_C_FLAGS "-Wextra")
  else()
    check_c_compiler_flag("-W" C_COMPILER_HAS_OLDER_WEXTRA)
    if(C_COMPILER_HAS_OLDER_WEXTRA)
      list(APPEND CUSTOM_CMAKE_C_FLAGS "-W")
    endif()
  endif()

  check_c_compiler_flag("-Wmissing-prototypes" C_COMPILER_HAS_WMISSING_PROTOTYPES)
  if(C_COMPILER_HAS_WMISSING_PROTOTYPES)
    list(APPEND CUSTOM_CMAKE_C_FLAGS "-Wmissing-prototypes")
  endif()

  check_c_compiler_flag("-Wstrict-prototypes" C_COMPILER_HAS_WSTRICT_PROTOTYPES)
  if(C_COMPILER_HAS_WSTRICT_PROTOTYPES)
    list(APPEND CUSTOM_CMAKE_C_FLAGS "-Wstrict-prototypes")
  endif()

  check_c_compiler_flag("-Wvla" C_COMPILER_HAS_WVLA)
  if(C_COMPILER_HAS_WVLA)
    list(APPEND CUSTOM_CMAKE_C_FLAGS "-Wvla")
  endif()

  string(REPLACE ";" " " CUSTOM_CMAKE_C_FLAGS "${CUSTOM_CMAKE_C_FLAGS}")
  set(CMAKE_C_FLAGS "${CUSTOM_CMAKE_C_FLAGS}")

  # basic debug flags
  # -----------------------------------------------------------------
  # -g -Og[-O0]
  # -----------------------------------------------------------------
  check_c_compiler_flag("-g" C_COMPILER_HAS_G)
  if(C_COMPILER_HAS_G)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_DEBUG "-g")
  endif()

  check_c_compiler_flag("-Og" C_COMPILER_HAS_OG)
  if(C_COMPILER_HAS_OG)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_DEBUG "-Og")
  else()
    check_c_compiler_flag("-O0" C_COMPILER_HAS_O0)
    if(C_COMPILER_HAS_O0)
      list(APPEND CUSTOM_CMAKE_C_FLAGS_DEBUG "-O0")
    endif()
  endif()

  # basic release flags
  # -----------------------------------------------------------------
  # -DNDEBUG
  # -O2 -fomit-frame-pointer
  # -----------------------------------------------------------------
  check_c_compiler_flag("-DNDEBUG" C_COMPILER_HAS_DNDEBUG)
  if(C_COMPILER_HAS_DNDEBUG)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_RELEASE "-DNDEBUG")
  endif()

  check_c_compiler_flag("-O2" C_COMPILER_HAS_O2)
  if(C_COMPILER_HAS_O2)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_RELEASE "-O2")
  endif()

  check_c_compiler_flag("-fomit-frame-pointer" C_COMPILER_HAS_FOMIT_FRAME_POINTER)
  if(C_COMPILER_HAS_FOMIT_FRAME_POINTER)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_RELEASE "-fomit-frame-pointer")
  endif()

  # extra release flags
  # -----------------------------------------------------------------
  # -fstack-protector-strong[-fstack-protector] -fno-plt
  # -----------------------------------------------------------------
  check_c_compiler_flag("-fstack-protector-strong" C_COMPILER_HAS_FSTACK_PROTECTOR_STRONG)
  if(C_COMPILER_HAS_FSTACK_PROTECTOR_STRONG)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_RELEASE "-fstack-protector-strong")
  else()
    check_c_compiler_flag("-fstack-protector" C_COMPILER_HAS_FSTACK_PROTECTOR)
    if(C_COMPILER_HAS_FSTACK_PROTECTOR)
      list(APPEND CUSTOM_CMAKE_C_FLAGS_RELEASE "-fstack-protector")
    endif()
  endif()

  check_c_compiler_flag("-fno-plt" C_COMPILER_HAS_FNO_PLT)
  if(C_COMPILER_HAS_FNO_PLT)
    list(APPEND CUSTOM_CMAKE_C_FLAGS_RELEASE "-fno-plt")
  endif()

  string(REPLACE ";" " " CUSTOM_CMAKE_C_FLAGS_DEBUG "${CUSTOM_CMAKE_C_FLAGS_DEBUG}")
  string(REPLACE ";" " " CUSTOM_CMAKE_C_FLAGS_RELEASE "${CUSTOM_CMAKE_C_FLAGS_RELEASE}")

  set(CMAKE_C_FLAGS_DEBUG "${CUSTOM_CMAKE_C_FLAGS_DEBUG}")
  set(CMAKE_C_FLAGS_RELEASE "${CUSTOM_CMAKE_C_FLAGS_RELEASE}")
else()
  set(CMAKE_C_STANDARD 99)
  set(CMAKE_C_STANDARD_REQUIRED ON)
  set(CMAKE_C_EXTENSIONS ON)
endif()
