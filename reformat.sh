#!/bin/sh

find ./include ./bin ./lib -name '*.cc' -print0 | xargs -0 -I {} clang-format -style=file -i {}
find ./include ./bin ./lib -name '*.h' -print0 | xargs -0 -I {} clang-format -style=file -i {}
