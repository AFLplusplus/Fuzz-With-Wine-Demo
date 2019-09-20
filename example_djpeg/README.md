# AFL++ Wine Mode - Djpeg Example

Fuzzing programs that requires user interaction is a very bad idea.
By default libjpeg reports assertion errors use MessageBoxA and so waits for user
interation without a real motivation.

To fuzz this kind of application you need to patch out this code.
In this example I patched the routine in libjpeg.dll that calls MessageBoxA.

Original:

```asm
.text:686DB2E0 sub_686DB2E0    proc near               ; DATA XREF: jpeg_std_error+13↑o
.text:686DB2E0
.text:686DB2E0 hWnd            = dword ptr -0ECh
.text:686DB2E0 lpText          = dword ptr -0E8h
.text:686DB2E0 lpCaption       = dword ptr -0E4h
.text:686DB2E0 uType           = dword ptr -0E0h
.text:686DB2E0 Text            = byte ptr -0DCh
.text:686DB2E0 var_4           = dword ptr -4
.text:686DB2E0 arg_0           = dword ptr  4
.text:686DB2E0
.text:686DB2E0                 sub     esp, 0ECh
.text:686DB2E6                 mov     edx, [esp+0ECh+arg_0]
.text:686DB2ED                 mov     [esp+0ECh+var_4], ebx
.text:686DB2F4                 lea     ebx, [esp+0ECh+Text]
.text:686DB2F8                 mov     ecx, [edx]
.text:686DB2FA                 mov     [esp+0ECh+lpText], ebx
.text:686DB2FE                 mov     [esp+0ECh+hWnd], edx
.text:686DB301                 call    dword ptr [ecx+0Ch]
.text:686DB304                 call    GetActiveWindow
.text:686DB309                 mov     [esp+0ECh+hWnd], eax ; hWnd
.text:686DB30C                 mov     [esp+0ECh+lpText], ebx ; lpText
.text:686DB310                 mov     [esp+0ECh+uType], 10h ; uType
.text:686DB318                 mov     [esp+0ECh+lpCaption], offset aJpegLibraryErr ; "JPEG Library Error"
.text:686DB320                 call    MessageBoxA
.text:686DB325                 sub     esp, 10h
.text:686DB328                 mov     ebx, [esp+0ECh+var_4]
.text:686DB32F                 add     esp, 0ECh
.text:686DB335                 retn
.text:686DB335 sub_686DB2E0    endp
```

Patched:

```asm
.text:686DB2E0 sub_686DB2E0    proc near               ; DATA XREF: jpeg_std_error+13↑o
.text:686DB2E0
.text:686DB2E0 var_EC          = dword ptr -0ECh
.text:686DB2E0 var_E8          = dword ptr -0E8h
.text:686DB2E0 var_E4          = dword ptr -0E4h
.text:686DB2E0 var_E0          = dword ptr -0E0h
.text:686DB2E0 var_DC          = byte ptr -0DCh
.text:686DB2E0 var_4           = dword ptr -4
.text:686DB2E0 arg_0           = dword ptr  4
.text:686DB2E0
.text:686DB2E0                 sub     esp, 0ECh
.text:686DB2E6                 mov     edx, [esp+0ECh+arg_0]
.text:686DB2ED                 mov     [esp+0ECh+var_4], ebx
.text:686DB2F4                 lea     ebx, [esp+0ECh+var_DC]
.text:686DB2F8                 mov     ecx, [edx]
.text:686DB2FA                 mov     [esp+0ECh+var_E8], ebx
.text:686DB2FE                 mov     [esp+0ECh+var_EC], edx
.text:686DB301                 call    dword ptr [ecx+0Ch]
.text:686DB304                 call    GetActiveWindow
.text:686DB309                 mov     [esp+0ECh+var_EC], eax
.text:686DB30C                 mov     [esp+0ECh+var_E8], ebx
.text:686DB310                 mov     [esp+0ECh+var_E0], 10h
.text:686DB318                 mov     [esp+0ECh+var_E4], offset aJpegLibraryErr ; "JPEG Library Error"
.text:686DB320                 mov     eax, 1          ; MessageBoxA returns 1 on "OK"
.text:686DB325                 sub     esp, 0          ; adjust stack pointer for parameters
.text:686DB328                 mov     ebx, [esp+0ECh+var_4]
.text:686DB32F                 add     esp, 0ECh
.text:686DB335                 retn
.text:686DB335 sub_686DB2E0    endp
```
