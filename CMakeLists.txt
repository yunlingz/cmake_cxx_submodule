# Copyright 2019 chuling <meetchuling@outlook.com>
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

cmake_minimum_required(VERSION 3.10)

project(example
  VERSION 0.0.1
  LANGUAGES CXX)

option(REQUIRES_RTTI "Build with RTTI enabled" OFF)
option(REQUIRES_PIPE "Build with -pipe" ON)
option(REQUIRES_MARCH_NATIVE "Build with -march=native" ON)
include(${PROJECT_SOURCE_DIR}/cmake/CXX17Enforce.cmake)

message(STATUS "${CMAKE_CXX_FLAGS}")
message(STATUS "${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "${CMAKE_CXX_FLAGS_RELEASE}")

option(BUILD_SHARED_LIBS "Create shared libraries" ON)
include(${PROJECT_SOURCE_DIR}/cmake/SubModule.cmake)

add_bin(TARGET_NAME sub_test LINK_TO example_sub)
# add_lib(TARGET_NAME some_bin_not_exist) # should trigger warning

add_lib(TARGET_NAME example_add LINK_TO)
add_lib(TARGET_NAME example_sub LINK_TO example_add)
# add_lib(TARGET_NAME some_lib_not_exist) # should trigger warning
