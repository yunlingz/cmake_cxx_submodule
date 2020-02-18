# Copyright 2012 Ling CHU <meetchuling@outlook.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os


def cxx_flags():
    # basic cxx flags
    flags = [
        "-std=c++17",
        "-pedantic",
        "-Wall",
        "-Wextra",
        "-fno-exceptions",
        "-fno-rtti",
    ]
    flags += ["-x", "c++"]
    # system include dirs
    system_inc_dirs = [
        # system: echo | clang -v -E -x c++ -
        # ---------------
    ]
    for inc_dir in system_inc_dirs:
        flags += ["-isystem", inc_dir]
    # custom include dirs
    custom_inc_dirs = [
        "/usr/local/Cellar/opencv/4.2.0_1/include/opencv4",
        "/usr/local/Cellar/eigen/3.3.7/include/eigen3",
        "/usr/local/Cellar/fmt/6.1.2/include",
        "include",
        "inner/include",
    ]
    for inc_dir in custom_inc_dirs:
        flags += ["-I{}".format(inc_dir)]
    return flags


def dir_of_this_script():
    return os.path.dirname(os.path.abspath(__file__))


def Settings(**kwargs):
    language = kwargs["language"]
    if language == "cfamily":
        return {
            "flags": cxx_flags(),
            "include_paths_relative_to_dir": dir_of_this_script(),
        }
    return {}
