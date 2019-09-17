# WineAFLplusplusDEMO

To fuzz Win32 PE applications with AFL++ QEMU you must ensure that your Linux
distribution is able to run Wine without preloader.

Check it simply typing:

```
$ WINELOADERNOEXEC=1 wine cmd
```

Copy the `afl-wine-trace` script into the AFL++ path or export AFL_PATH.

To fuzz a PE run it like in the following example with pnginfo.exe:

```
AFL_SKIP_BIN_CHECK=1 ~/AFLplusplus/afl-fuzz -i in/ -o out -d -m none -- ~/AFLplusplus/afl-wine-trace ./pnginfo.exe @@
```

AFL_SKIP_BIN_CHECK is needed cause afl-wine-trace is no a binary.

The following screen should be familiar to you:

![expic](img/pnginfo_example.png)
