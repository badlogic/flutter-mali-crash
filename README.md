# Flutter Mali Crash
This is a reproduction sample for `Canvas.drawVertices()` crashing reliably on the Google Pixel 6 Pro, Android 12, Build number SQ3A.220705.004.

The app creates an `ImageShader` based `Paint` from an image (`assets/spineboy.png`) and loads a simple triangle soup (`assets/spineboy.mesh`, 276 vertices, 1029 indices). The mesh data is converted to a `Vertices` instance.

The app then proceeds to draw the `Vertices` instance to a canvas 12 times, at random positions. This results in the Mali GPU driver crashing, despite all data submitted through `drawVertices()` being valid.

```
Launching lib/main.dart on Pixel 6 Pro in debug mode...
Running Gradle task 'assembleDebug'...
✓  Built build/app/outputs/flutter-apk/app-debug.apk.
Debug service listening on ws://127.0.0.1:53168/3DcgIVZeh4Y=/ws
Syncing files to device Pixel 6 Pro...
F/libc    ( 6987): Fatal signal 11 (SIGSEGV), code 2 (SEGV_ACCERR), fault addr 0xb40000717ce88000 in tid 7026 (1.raster), pid 6987 (tter_mali_crash)
*** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
Build fingerprint: 'google/raven/raven:12/SQ3A.220705.004/8836240:user/release-keys'
Revision: 'MP1.0'
ABI: 'arm64'
Timestamp: 2022-11-23 13:14:19.095206736+0100
Process uptime: 0s
Cmdline: com.example.flutter_mali_crash
pid: 6987, tid: 7026, name: 1.raster  >>> com.example.flutter_mali_crash <<<
uid: 10298
tagged_addr_ctrl: 0000000000000001
signal 11 (SIGSEGV), code 2 (SEGV_ACCERR), fault addr 0xb40000717ce88000
    x0  0000005efe84c000  x1  b40000717ce87fc0  x2  0000000000000004  x3  0000005efe85c280
    x4  b40000717ce88014  x5  0000005efe85c2d4  x6  430600084449c001  x7  44abf462443ffd55
    x8  4449c001ffffffff  x9  444ce8ce42b9fff8  x10 ffffffff44aacc7f  x11 42b9fff844533ffb
    x12 4442845843060008  x13 ffffffff44b30478  x14 0000000000000034  x15 0000000000000000
    x16 0000006ea2f47f10  x17 0000007173666860  x18 0000006e3efba000  x19 0000000000000000
    x20 0000000000000000  x21 b40000701f5bc510  x22 0000005efe84c000  x23 0000000000000000
    x24 00000000000102d4  x25 b40000701f5bc510  x26 b40000701f5bc510  x27 0000000000000cf1
    x28 0000000000000028  x29 b400006e21df0fe8
    lr  0000006ea11ed308  sp  0000006e3f15e780  pc  000000717366681c  pst 0000000020001000
backtrace:
      #00 pc 000000000004b81c  /apex/com.android.runtime/lib64/bionic/libc.so (__memcpy+300) (BuildId: 53a228529316d67f22e241dd17ea9b9e)
      #01 pc 0000000000761304  /vendor/lib64/egl/libGLES_mali.so (BuildId: 5449cdfd08974e81)
      #02 pc 00000000007886f8  /vendor/lib64/egl/libGLES_mali.so (BuildId: 5449cdfd08974e81)
      #03 pc 000000000076880c  /vendor/lib64/egl/libGLES_mali.so (BuildId: 5449cdfd08974e81)
      #04 pc 000000000070d5c8  /vendor/lib64/egl/libGLES_mali.so (BuildId: 5449cdfd08974e81)
      #05 pc 00000000017f6938  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #06 pc 000000000185dd88  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #07 pc 000000000185dc64  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #08 pc 00000000017ec6c8  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #09 pc 00000000017ec440  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #10 pc 00000000017ec9fc  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #11 pc 00000000016c4bec  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #12 pc 0000000001a12f60  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #13 pc 00000000018ed4f4  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #14 pc 00000000018ed490  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #15 pc 00000000019046cc  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #16 pc 0000000001903d88  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #17 pc 0000000001904b7c  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #18 pc 00000000019035c4  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #19 pc 0000000001903334  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #20 pc 0000000001910300  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #21 pc 00000000015e598c  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #22 pc 00000000015eb244  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #23 pc 00000000000167e8  /system/lib64/libutils.so (android::Looper::pollInner(int)+908) (BuildId: 686c31d894348488b4a8cd7a98a6d303)
      #24 pc 00000000000163f4  /system/lib64/libutils.so (android::Looper::pollOnce(int, int*, int*, void**)+112) (BuildId: 686c31d894348488b4a8cd7a98a6d303)
      #25 pc 0000000000017154  /system/lib64/libandroid.so (ALooper_pollOnce+100) (BuildId: 60cbdc2b390b6fecfbb762cadc5086cf)
      #26 pc 00000000015eb1cc  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #27 pc 00000000015e58e8  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #28 pc 00000000015e9844  /data/app/~~NNSOfmYoRNzQBcWFZ4TGsQ==/com.example.flutter_mali_crash-S_0OiJuFYyX3swYnthEngw==/lib/arm64/libflutter.so (BuildId: ac81dbe6a14145f04ad79b76cf9e5e3c681a3cf3)
      #29 pc 00000000000b1590  /apex/com.android.runtime/lib64/bionic/libc.so (__pthread_start(void*)+204) (BuildId: 53a228529316d67f22e241dd17ea9b9e)
      #30 pc 0000000000050fac  /apex/com.android.runtime/lib64/bionic/libc.so (__start_thread+64) (BuildId: 53a228529316d67f22e241dd17ea9b9e)
```

The same app works fine on any Android emulator, as well as a Galaxy Tab S6 (Android 12). This may be a bug in the Google Pixel 6 Pro GPU driver for that specific build.