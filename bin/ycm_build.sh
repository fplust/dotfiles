cmake -G Unix Makefiles -DPATH_TO_LLVM_ROOT=~/ycmtemp/clang+llvm-3.8.0-x86_64-opensuse13.2 -DUSE_PYTHON2=OFF . ~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp
cmake --build . --target ycm_core
