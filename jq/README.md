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
