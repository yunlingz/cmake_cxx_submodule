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

# predefined options
option(REQUIRES_RTTI "Build with RTTI enabled" OFF)
option(REQUIRES_PIPE "Build with -pipe" ON)
option(REQUIRES_MARCH_NATIVE "Build with -march=native" ON)

string(TOLOWER "${CMAKE_BUILD_TYPE}" LOWERCASE_CMAKE_BUILD_TYPE)
if(LOWERCASE_CMAKE_BUILD_TYPE STREQUAL "debug")
  set(CMAKE_BUILD_TYPE "Debug")
  message(STATUS "Set build type to debug")
else()
  set(CMAKE_BUILD_TYPE "Release")
  message(STATUS "Set build type to release")
endif()

if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  include(CheckCXXCompilerFlag)
  # basic c++17 flags
  # -----------------------------------------------------------------
  # -std=c++17 -pedantic -Wall -Wextra
  # -----------------------------------------------------------------
  check_cxx_compiler_flag("-std=c++17" CXX_COMPILER_HAS_CXX17_SUPPORT)
  if (CXX_COMPILER_HAS_CXX17_SUPPORT)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-std=c++17")
  else()
    message(FATAL_ERROR "${CMAKE_CXX_COMPILER_ID} has no C++17 support")
  endif()

  check_cxx_compiler_flag("-pedantic" CXX_COMPILER_HAS_PEDANTIC)
  if(CXX_COMPILER_HAS_PEDANTIC)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-pedantic")
  endif()

  check_cxx_compiler_flag("-Wall" CXX_COMPILER_HAS_WALL)
  if(CXX_COMPILER_HAS_WALL)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-Wall")
  endif()

  check_cxx_compiler_flag("-Wextra" CXX_COMPILER_HAS_WEXTRA)
  if(CXX_COMPILER_HAS_WEXTRA)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-Wextra")
  else()
    check_cxx_compiler_flag("-W" CXX_COMPILER_HAS_OLDER_WEXTRA)
    if(CXX_COMPILER_HAS_OLDER_WEXTRA)
      list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-W")
    endif()
  endif()

  # disable exception and rtti
  # -----------------------------------------------------------------
  # -fno-exceptions (-fno-rtti)
  # -----------------------------------------------------------------
  check_cxx_compiler_flag("-fno-exceptions" CXX_COMPILER_HAS_FNO_EXCEPTIONS)
  if(CXX_COMPILER_HAS_FNO_EXCEPTIONS)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-fno-exceptions")
  endif()

  if(NOT REQUIRES_RTTI)
    check_cxx_compiler_flag("-fno-rtti" CXX_COMPILER_HAS_FNO_RTTI)
    if(CXX_COMPILER_HAS_FNO_RTTI)
      list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-fno-rtti")
    endif()
  endif()

  # enable pipe
  # -----------------------------------------------------------------
  # (-pipe)
  # -----------------------------------------------------------------
  if(REQUIRES_PIPE)
    check_cxx_compiler_flag("-pipe" CXX_COMPILER_HAS_PIPE)
    if(CXX_COMPILER_HAS_PIPE)
      list(APPEND CUSTOM_CMAKE_CXX_FLAGS "-pipe")
    endif()
  endif()

  string(REPLACE ";" " " CUSTOM_CMAKE_CXX_FLAGS "${CUSTOM_CMAKE_CXX_FLAGS}")
  set(CMAKE_CXX_FLAGS "${CUSTOM_CMAKE_CXX_FLAGS}")

  # basic debug flags
  # -----------------------------------------------------------------
  # -g -Og
  # -----------------------------------------------------------------
  check_cxx_compiler_flag("-g" CXX_COMPILER_HAS_G)
  if(CXX_COMPILER_HAS_G)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_DEBUG "-g")
  endif()

  check_cxx_compiler_flag("-Og" CXX_COMPILER_HAS_OG)
  if(CXX_COMPILER_HAS_OG)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_DEBUG "-Og")
  endif()

  # basic release flags
  # -----------------------------------------------------------------
  # (-march=native) -O3 -DNDEBUG -fomit-frame-pointer
  # -----------------------------------------------------------------
  if(REQUIRES_MARCH_NATIVE)
    check_cxx_compiler_flag("-march=native" CXX_COMPILER_HAS_MARCH_NATIVE)
    if(CXX_COMPILER_HAS_MARCH_NATIVE)
      list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-march=native")
    endif()
  endif()

  check_cxx_compiler_flag("-O3" CXX_COMPILER_HAS_O3)
  if(CXX_COMPILER_HAS_O3)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-O3")
  endif()

  check_cxx_compiler_flag("-DNDEBUG" CXX_COMPILER_HAS_DNDEBUG)
  if(CXX_COMPILER_HAS_DNDEBUG)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG")
  endif()

  check_cxx_compiler_flag("-fomit-frame-pointer" CXX_COMPILER_HAS_FOMIT_FRAME_POINTER)
  if(CXX_COMPILER_HAS_FOMIT_FRAME_POINTER)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-fomit-frame-pointer")
  endif()

  # extra release flags
  # -----------------------------------------------------------------
  # -fstack-protector-strong -fno-plt
  # -flto
  # -----------------------------------------------------------------
  check_cxx_compiler_flag("-fstack-protector-strong" CXX_COMPILER_HAS_FSTACK_PROTECTOR_STRONG)
  if(CXX_COMPILER_HAS_FSTACK_PROTECTOR_STRONG)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-fstack-protector-strong")
  endif()

  check_cxx_compiler_flag("-fno-plt" CXX_COMPILER_HAS_FNO_PLT)
  if(CXX_COMPILER_HAS_FNO_PLT)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-fno-plt")
  endif()

  check_cxx_compiler_flag("-flto" CXX_COMPILER_HAS_FLTO)
  if(CXX_COMPILER_HAS_FLTO)
    list(APPEND CUSTOM_CMAKE_CXX_FLAGS_RELEASE "-flto")
  endif()

  string(REPLACE ";" " " CUSTOM_CMAKE_CXX_FLAGS_DEBUG "${CUSTOM_CMAKE_CXX_FLAGS_DEBUG}")
  string(REPLACE ";" " " CUSTOM_CMAKE_CXX_FLAGS_RELEASE "${CUSTOM_CMAKE_CXX_FLAGS_RELEASE}")

  set(CMAKE_CXX_FLAGS_DEBUG "${CUSTOM_CMAKE_CXX_FLAGS_DEBUG}")
  set(CMAKE_CXX_FLAGS_RELEASE "${CUSTOM_CMAKE_CXX_FLAGS_RELEASE}")
else()
  set(CMAKE_CXX_STANDARD 17)
  set(CMAKE_CXX_STANDARD_REQUIRED ON)
  set(CMAKE_CXX_EXTENSIONS OFF)
endif()
