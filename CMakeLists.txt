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
  LANGUAGES CXX C)

include(${PROJECT_SOURCE_DIR}/cmake/CXX17Enforce.cmake)
message(STATUS "${CMAKE_CXX_FLAGS}")
message(STATUS "${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "${CMAKE_CXX_FLAGS_RELEASE}")

include(${PROJECT_SOURCE_DIR}/cmake/GNU99Enforce.cmake)
message(STATUS "${CMAKE_C_FLAGS}")
message(STATUS "${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "${CMAKE_C_FLAGS_RELEASE}")

include(${PROJECT_SOURCE_DIR}/cmake/SubModule.cmake)

add_subdirectory(${PROJECT_SOURCE_DIR}/gtest EXCLUDE_FROM_ALL)

add_inc(TGT include)
add_inc(TGT inner/include PVT)
# add_inc(TGT inner/include_2)

add_bin(TGT sub_test
  SRC bin/sub_test/test.cc
  DEP example_sub)
# add_lib(TGT some_bin_not_exist) # should trigger warning

add_lib(TGT example_add PVT
  SRC inner/lib/example_add/add_one.cc inner/lib/example_add/add.cc
  DEP
  COMPILE_FLAGS -fexceptions -frtti)

add_lib(TGT example_sub
  SRC lib/example_sub/sub.cc
  DEP example_add)
# add_lib(TGT some_lib_not_exist) # should trigger warning

add_bin(TGT run_test PVT
  SRC inner/bin/run_test/test_1.cc inner/bin/run_test/test_2.cc
  DEP gtest_main)

add_bin(TGT c_bin PVT
  SRC bin/c_bin/main.c)
