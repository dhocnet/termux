Shell Script Compiler
========================

A generic shell script compiler. Shc takes a script, which is specified on the command line and produces C source code. The generated source code is then compiled and linked to produce a stripped binary executable. The compiled binary will still be dependent on the shell specified in the first line of the shell code (i.e shebang) (i.e. #!/bin/sh), thus shc does not create completely independent binaries. shc itself is not a compiler such as cc, it rather encodes and encrypts a shell script and generates C source code with the added expiration capability. It then uses the system compiler to compile a stripped binary which behaves exactly like the original script. Upon execution, the compiled binary will decrypt and execute the code with the shell -c option.

*
* Paket dikemas khusus untuk Termux (arm)
*

instalasi
========================
$ pkg install ./namafile-versi.deb


Kode sumber: https://github.com/neurobin/shc
