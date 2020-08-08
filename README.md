# llvm-linux

## 1. install gcc 9 and ninja
```
sudo add-apt-repository ppa:jonathonf/gcc-9.0
sudo apt update
sudo apt-get install gcc-9 g++-9
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9
```

if on Ubuntu 20.04, gcc 9.3.0. 
```  
sudo apt-add-repository -r ppa:jonathonf/gcc-9.0
sudo apt update -q
sudo apt-get update
sudo apt-get upgrade
```
Installl Ninja 

```
sudo apt-get install python
sudo apt-get update -y
sudo apt-get install -y re2c

git clone git://github.com/martine/ninja.git
cd ninja/
./configure.py --bootstrap
sudo cp ninja /usr/local/bin/
sudo chmod a+rx /usr/local/bin/ninja
```

## 2. Install LLVM

### 2.1 install llvm 10.0 from git repo
```
sudo apt-get install build-essential gcc-9-plugin-dev clang ninja-build cmake libncurses5-dev libelf-dev libssl-dev flex bison bc git pigz
// git clone https://github.com/llvm/llvm-project.git
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



### 2.2 install llvm 9.0 from git repo
```
sudo apt-get install build-essential gcc-9-plugin-dev clang ninja-build cmake libncurses5-dev libelf-dev libssl-dev flex bison bc git pigz
git clone https://github.com/llvm/llvm-project.git
cd llvm-project
git checkout release/9.x
mkdir build
cd build

cmake -G Ninja -DLLVM_ENABLE_PROJECTS='clang;lld;compiler-rt' \
-DCMAKE_BUILD_TYPE=Release -DLLVM_ENABLE_WARNINGS=OFF \
-DCMAKE_INSTALL_PREFIX=/usr/local/llvm-9 ../llvm

ninja
sudo ninja install
```

### 2.3 install llvm 9.0 from download (preferred)
From ` https://releases.llvm.org/download.html `, download Download LLVM 9.0.0, ***llvm-9.0.0.src.tar.xz***

```
sudo apt-get install build-essential gcc-9-plugin-dev clang ninja-build cmake libncurses5-dev libelf-dev libssl-dev flex bison bc git pigz
tar -xf  llvm-9.0.0.src.tar.xz
cd llvm-9.0.0.src
mkdir build
cd build

cmake -DCMAKE_BUILD_TYPE=Debug -DLLVM_TARGETS_TO_BUILD=X86 ..
cmake --build .
```

Then you could
```
export LLVM_HOME=/home/wenhui/llvm-9.0.0.src
```
Or add above line to 
```
vim ~/.bashrc 
source ~/.bashrc 
echo $LLVM_HOME
```
Then install LLVM
```
cmake -DCMAKE_INSTALL_PREFIX=$LLVM_HOME -P cmake_install.cmake

```

## 3. add patch to linux and compile

The code is already patched, if you would like to start from vanilla source code, this is where to get started.

Download kernel source from here : https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/

For Linux 5.4.38
```
cd linux-5.4.38
patch -p1 < ./../patch/5-4-38/patch1.patch
patch -p1 < ./../patch/5-4-38/patch2.patch
patch -p1 < ./../patch/5-4-38/gzip.diff
```
For Linux 5.3.0
```
cd linux-5.3.0
patch -p1 < ./../patch/5-3-0/patch1.patch
patch -p1 < ./../patch/5-3-0/patch2.patch
patch -p1 < ./../patch/5-3-0/patch3.patch
```

## 4. make 

### 4.1 make kernel with llvm-10
```
// make allyesconfig
// scripts/config --disable CONFIG_X86_DECODER_SELFTEST
// scripts/config --disable CONFIG_MODULE_SIG
// scripts/config --disable CONFIG_DEBUG_INFO

cp config .config
```
```
export PATH=/usr/local/llvm-10/bin:$PATH

OR

export PATH=/home/wenhui/llvm-10.0.0.src/build/bin:$PATH
```
```
make -j4 LD=ld.lld HOSTLDFLAGS=-fuse-ld=lld KGZIP=pigz
```

### 4.2 make kernel with llvm-9
make sure you have $LLVM_HOME setup in step ***2.3***

```
// make allyesconfig
// scripts/config --disable CONFIG_X86_DECODER_SELFTEST
// scripts/config --disable CONFIG_MODULE_SIG
// scripts/config --disable CONFIG_DEBUG_INFO

cp config .config
export PATH=$LLVM_HOME/bin:$PATH
make -j4 LD=ld.lld HOSTLDFLAGS=-fuse-ld=lld KGZIP=pigz
```


## 5. install
```
sudo make modules_install
sudo make install
sudo update-grub2
sudo reboot
```


# Ref:

- Debian Install: https://apt.llvm.org/
- opt usage: https://llvm.org/docs/CommandGuide/opt.html

