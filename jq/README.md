```shell
# build binary (host native no cross comp) ; x86_64 in my case
# works fine: ./jq: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, BuildID[sha1]=abd6b8cee389245b61aed3bff8930a6905211a4e, with debug_info, not stripped
docker buildx bake

# build binary against linux/arm/v7 (cross-comp)
# works fine: ./jq: ELF 32-bit LSB executable, ARM, EABI5 version 1 (SYSV), statically linked, Go BuildID=qlVUduOYTGlPYuaGysGc/sXp9hyuDA9hgNmiGfGQo/oMzSOeC0SyFYjfSqsQLt/yoWeDA4bdqEXkPq6SXr4, BuildID[xxHash]=9d1b9d4800ffb8a0, with debug_info, not stripped
docker buildx bake --set *.platform=linux/arm/v7

# build binary against linux/riscv64 (cross-comp)
# segfault:
# 3.957 /usr/lib/go/pkg/tool/linux_amd64/link: running riscv64-alpine-linux-musl-clang failed: exit status 1
# 3.957 clang-16: error: unable to execute command: Segmentation fault
# 3.957 clang-16: error: linker command failed due to signal (use -v to see invocation)
docker buildx bake  --set *.platform=linux/riscv64
```

Debug output of `docker buildx bake  --set *.platform=linux/riscv64` with `-v` passed to `CGO_CFLAGS`:

```
#14 [stage-0 6/6] RUN --mount=type=bind,source=.,rw   CGO_ENABLED=1 CGO_CFLAGS='-O2 -g -v' xx-go build -ldflags '-extldflags -static' -o ./jq &&   file ./jq
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name _cgo_export.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b054 -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/tmp/go-build3209687361/b054 -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x001.o -x c _cgo_export.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name cgo.cgo2.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b054 -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/tmp/go-build3209687361/b054 -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x002.o -x c cgo.cgo2.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_context.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x003.o -x c gcc_context.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_fatalf.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x004.o -x c gcc_fatalf.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_libinit.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x005.o -x c gcc_libinit.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_linux_riscv64.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x006.o -x c gcc_linux_riscv64.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_setenv.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x007.o -x c gcc_setenv.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_stack_unix.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x008.o -x c gcc_stack_unix.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_traceback.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x009.o -x c gcc_traceback.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_util.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x010.o -x c gcc_util.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name linux_syscall.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_x011.o -x c linux_syscall.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -E -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name gcc_riscv64.S -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/usr/lib/go/src/runtime/cgo -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o /tmp/gcc_riscv64-c94c06.s -x assembler-with-cpp gcc_riscv64.S
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1as -triple riscv64-alpine-linux-musl -filetype obj -main-file-name gcc_riscv64.S -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -fdebug-compilation-dir=/usr/lib/go/src/runtime/cgo -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -dwarf-debug-producer "Alpine clang version 16.0.6" -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -debug-info-kind=constructor -dwarf-version=5 -mrelocation-model pic -target-abi lp64d -object-file-name=/tmp/go-build3209687361/b054/_x012.o -o $WORK/b054/_x012.o /tmp/gcc_riscv64-c94c06.s
#14 3.428 # runtime/cgo
#14 3.428 Alpine clang version 16.0.6
#14 3.428 Target: riscv64-alpine-linux-musl
#14 3.428 Thread model: posix
#14 3.428 InstalledDir: /usr/bin
#14 3.428 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 3.428 System configuration file directory: /etc/clang16
#14 3.428 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 3.428  (in-process)
#14 3.428  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name _cgo_main.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b054 -resource-dir /usr/lib/llvm16/lib/clang/16 -I /usr/lib/go/src/runtime/cgo -I $WORK/b054/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fmacro-prefix-map=/usr/lib/go=/_/GOROOT -fcoverage-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fcoverage-prefix-map=/usr/lib/go=/_/GOROOT -O2 -Wall -Werror -fdebug-compilation-dir=/tmp/go-build3209687361/b054 -fdebug-prefix-map=/tmp/go-build3209687361/b054=/tmp/go-build -fdebug-prefix-map=/usr/lib/go=/_/GOROOT -ferror-limit 19 -pthread -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b054/_cgo_main.o -x c _cgo_main.c
#14 3.428 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 3.428 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 3.428 #include "..." search starts here:
#14 3.428 #include <...> search starts here:
#14 3.428  /usr/lib/go/src/runtime/cgo
#14 3.428  $WORK/b054
#14 3.428  /riscv64-alpine-linux-musl/usr/include
#14 3.428  /usr/lib/llvm16/lib/clang/16/include
#14 3.428 End of search list.
#14 4.004 # jq
#14 4.004 Alpine clang version 16.0.6
#14 4.004 Target: riscv64-alpine-linux-musl
#14 4.004 Thread model: posix
#14 4.004 InstalledDir: /usr/bin
#14 4.004 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 4.004 System configuration file directory: /etc/clang16
#14 4.004 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004  (in-process)
#14 4.004  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name _cgo_export.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b001 -resource-dir /usr/lib/llvm16/lib/clang/16 -I . -I $WORK/b001/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -fcoverage-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -O2 -fdebug-compilation-dir=/tmp/go-build3209687361/b001 -fdebug-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -ferror-limit 19 -pthread -stack-protector 2 -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b001/_x001.o -x c _cgo_export.c
#14 4.004 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 4.004 #include "..." search starts here:
#14 4.004 #include <...> search starts here:
#14 4.004  .
#14 4.004  $WORK/b001
#14 4.004  /riscv64-alpine-linux-musl/usr/include
#14 4.004  /usr/lib/llvm16/lib/clang/16/include
#14 4.004 End of search list.
#14 4.004 # jq
#14 4.004 Alpine clang version 16.0.6
#14 4.004 Target: riscv64-alpine-linux-musl
#14 4.004 Thread model: posix
#14 4.004 InstalledDir: /usr/bin
#14 4.004 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 4.004 System configuration file directory: /etc/clang16
#14 4.004 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004  (in-process)
#14 4.004  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name cgo.cgo2.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b001 -resource-dir /usr/lib/llvm16/lib/clang/16 -I . -I $WORK/b001/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -fcoverage-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -O2 -fdebug-compilation-dir=/tmp/go-build3209687361/b001 -fdebug-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -ferror-limit 19 -pthread -stack-protector 2 -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b001/_x002.o -x c cgo.cgo2.c
#14 4.004 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 4.004 #include "..." search starts here:
#14 4.004 #include <...> search starts here:
#14 4.004  .
#14 4.004  $WORK/b001
#14 4.004  /riscv64-alpine-linux-musl/usr/include
#14 4.004  /usr/lib/llvm16/lib/clang/16/include
#14 4.004 End of search list.
#14 4.004 # jq
#14 4.004 Alpine clang version 16.0.6
#14 4.004 Target: riscv64-alpine-linux-musl
#14 4.004 Thread model: posix
#14 4.004 InstalledDir: /usr/bin
#14 4.004 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 4.004 System configuration file directory: /etc/clang16
#14 4.004 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004  (in-process)
#14 4.004  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name exec.cgo2.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b001 -resource-dir /usr/lib/llvm16/lib/clang/16 -I . -I $WORK/b001/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -fcoverage-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -O2 -fdebug-compilation-dir=/tmp/go-build3209687361/b001 -fdebug-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -ferror-limit 19 -pthread -stack-protector 2 -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b001/_x003.o -x c exec.cgo2.c
#14 4.004 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 4.004 #include "..." search starts here:
#14 4.004 #include <...> search starts here:
#14 4.004  .
#14 4.004  $WORK/b001
#14 4.004  /riscv64-alpine-linux-musl/usr/include
#14 4.004  /usr/lib/llvm16/lib/clang/16/include
#14 4.004 End of search list.
#14 4.004 # jq
#14 4.004 Alpine clang version 16.0.6
#14 4.004 Target: riscv64-alpine-linux-musl
#14 4.004 Thread model: posix
#14 4.004 InstalledDir: /usr/bin
#14 4.004 Configuration file: /usr/lib/llvm16/bin/riscv64-alpine-linux-musl.cfg
#14 4.004 System configuration file directory: /etc/clang16
#14 4.004 Found candidate GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004 Selected GCC installation: /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1
#14 4.004  (in-process)
#14 4.004  "/usr/lib/llvm16/bin/clang-16" -cc1 -triple riscv64-alpine-linux-musl -emit-obj -disable-free -clear-ast-before-backend -disable-llvm-verifier -discard-value-names -main-file-name _cgo_main.c -mrelocation-model pic -pic-level 2 -mframe-pointer=none -ffp-contract=on -fno-rounding-math -mconstructor-aliases -target-cpu generic-rv64 -target-feature +m -target-feature +a -target-feature +f -target-feature +d -target-feature +c -target-feature -e -target-feature -h -target-feature -zihintpause -target-feature -zfhmin -target-feature -zfh -target-feature -zfinx -target-feature -zdinx -target-feature -zhinxmin -target-feature -zhinx -target-feature -zba -target-feature -zbb -target-feature -zbc -target-feature -zbs -target-feature -zbkb -target-feature -zbkc -target-feature -zbkx -target-feature -zknd -target-feature -zkne -target-feature -zknh -target-feature -zksed -target-feature -zksh -target-feature -zkr -target-feature -zkn -target-feature -zks -target-feature -zkt -target-feature -zk -target-feature -zmmul -target-feature -v -target-feature -zvl32b -target-feature -zvl64b -target-feature -zvl128b -target-feature -zvl256b -target-feature -zvl512b -target-feature -zvl1024b -target-feature -zvl2048b -target-feature -zvl4096b -target-feature -zvl8192b -target-feature -zvl16384b -target-feature -zvl32768b -target-feature -zvl65536b -target-feature -zve32x -target-feature -zve32f -target-feature -zve64x -target-feature -zve64f -target-feature -zve64d -target-feature -zicbom -target-feature -zicboz -target-feature -zicbop -target-feature -svnapot -target-feature -svpbmt -target-feature -svinval -target-feature -xventanacondops -target-feature -xtheadvdot -target-feature -experimental-zihintntl -target-feature -experimental-zca -target-feature -experimental-zcd -target-feature -experimental-zcf -target-feature -experimental-zvfh -target-feature -experimental-zawrs -target-feature -experimental-ztso -target-feature +relax -target-feature -save-restore -target-abi lp64d -msmall-data-limit 0 -mllvm -treat-scalable-fixed-error-as-warning -debug-info-kind=constructor -dwarf-version=5 -debugger-tuning=gdb -v -fcoverage-compilation-dir=/tmp/go-build3209687361/b001 -resource-dir /usr/lib/llvm16/lib/clang/16 -I . -I $WORK/b001/ -isysroot /riscv64-alpine-linux-musl/ -internal-isystem /riscv64-alpine-linux-musl/usr/local/include -internal-isystem /riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include/fortify -internal-externc-isystem /riscv64-alpine-linux-musl/usr/include -internal-isystem /usr/lib/llvm16/lib/clang/16/include -fmacro-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -fcoverage-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -O2 -fdebug-compilation-dir=/tmp/go-build3209687361/b001 -fdebug-prefix-map=/tmp/go-build3209687361/b001=/tmp/go-build -ferror-limit 19 -pthread -stack-protector 2 -fno-signed-char -fgnuc-version=4.2.1 -fno-caret-diagnostics -vectorize-loops -vectorize-slp -faddrsig -D__GCC_HAVE_DWARF2_CFI_ASM=1 -o $WORK/b001/_cgo_main.o -x c _cgo_main.c
#14 4.004 clang -cc1 version 16.0.6 based upon LLVM 16.0.6 default target x86_64-alpine-linux-musl
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/local/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/lib/gcc/riscv64-alpine-linux-musl/13.1.1/../../../../riscv64-alpine-linux-musl/include"
#14 4.004 ignoring nonexistent directory "/riscv64-alpine-linux-musl/usr/include/fortify"
#14 4.004 #include "..." search starts here:
#14 4.004 #include <...> search starts here:
#14 4.004  .
#14 4.004  $WORK/b001
#14 4.004  /riscv64-alpine-linux-musl/usr/include
#14 4.004  /usr/lib/llvm16/lib/clang/16/include
#14 4.004 End of search list.
#14 4.373 # jq
#14 4.373 /usr/lib/go/pkg/tool/linux_amd64/link: running riscv64-alpine-linux-musl-clang failed: exit status 1
#14 4.373 clang-16: error: unable to execute command: Segmentation fault
#14 4.373 clang-16: error: linker command failed due to signal (use -v to see invocation)
#14 4.373
#14 ERROR: process "/bin/sh -c CGO_ENABLED=1 CGO_CFLAGS='-O2 -g -v' xx-go build -ldflags '-extldflags -static' -o ./jq &&   file ./jq" did not complete successfully: exit code: 1
------
 > [stage-0 6/6] RUN --mount=type=bind,source=.,rw   CGO_ENABLED=1 CGO_CFLAGS='-O2 -g -v' xx-go build -ldflags '-extldflags -static' -o ./jq &&   file ./jq:
4.004  .
4.004  $WORK/b001
4.004  /riscv64-alpine-linux-musl/usr/include
4.004  /usr/lib/llvm16/lib/clang/16/include
4.004 End of search list.
4.373 # jq
4.373 /usr/lib/go/pkg/tool/linux_amd64/link: running riscv64-alpine-linux-musl-clang failed: exit status 1
4.373 clang-16: error: unable to execute command: Segmentation fault
4.373 clang-16: error: linker command failed due to signal (use -v to see invocation)
4.373
```
