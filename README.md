# llvm-linux-5.4

## 1. install gcc 9
```
sudo add-apt-repository ppa:jonathonf/gcc-9.0
sudo apt update
sudo apt-get install gcc-9 g++-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
```

## 2. install llvm
```
sudo apt-get install build-essential gcc-9-plugin-dev clang ninja-build cmake libncurses5-dev libelf-dev libssl-dev flex bison bc git pigz
https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout release/10.x
mkdir build
cd build

cmake -G Ninja -DLLVM_ENABLE_PROJECTS='clang;lld;compiler-rt' \
-DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF \
-DCMAKE_INSTALL_PREFIX=/usr/local/llvm-10 ../llvm

ninja
sudo ninja install
```

## 3. add patch to linux5.4 and compile
