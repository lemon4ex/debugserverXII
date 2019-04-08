### 项目简介

用于解决在系统为`iOS12`的越狱设备上使用debugserver调试应用时出现 `Terminated due to code signing error` 错误的问题。

解决方案使用大神[@Morpheus______](http://twitter.com/Morpheus______)写的[QiLin(麒麟)](http://newosxbook.com/QiLin/)工具，思路参考他写的[一篇文章](http://newosxbook.com/articles/MDGA.html)

* csflags: 单独的工具，只支持iOS12，[原网页](http://newosxbook.com/articles/MDGA.html)中的`csflags`貌似只支持iOS11，这里重新写一个。
* debugserverXII: 包装debugserver以便绕过签名错误的问题。工具在iOS12.0 + iPhone7(iPhone9,1)下测试通过。

### 使用教程

#### csflags
参考作者[原网页](http://newosxbook.com/articles/MDGA.html)的用法，这里不馈述。

#### debugserverXII
将编译好的二进制文件拷贝到越狱设备`/jb/debugserverXII`中，赋予可执行权限并签名
```
iPhone-7:~ root# chmod +x /jb/debugserverXII
iPhone-7:~ root# ldid -S/jb/entitlements.plist -M -K/usr/share/jailbreak/signcert.p12 /jb/debugserverXII

```

其中，`/jb/entitlements.plist`内容如下：
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>platform-application</key>
	<true/>
</dict>
</plist>
```

调试时，直接执行如下代码即可：
```
iPhone-7:~ root# /jb/debugserverXII localhost:1111 -a SpringBoard
```

注意：`debugserver`的路径必须为`/usr/bin/debugserver`，`debugserverXII`需要用到它。

由于`debugserverXII`是`debugserver`的包装，因此它可以使用的参数和`debugserver`一致。

### 已知问题
到目前为止，[QiLin(麒麟)ToolKit](http://newosxbook.com/QiLin/)默认只支持如下设备和系统，[原文地址](http://newosxbook.com/forum/viewtopic.php?f=15&t=19641)：
```
//iOS 12.1.2 - iPhone X
{ "12.1.1", "iPhone11,2", "D331AP", "_kernproc", 0xfffffff00913c638},
{ "12.1.2", "iPhone11,6", "D331AP", "_kernproc", 0xfffffff00913c638},
{ "12.1.1", "iPhone11,6", "D331AP", "_kernproc", 0xfffffff00913c638},


{ "12.1.1", "iPhone10,6", "D221AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,6", "D221AP", "_kernproc", 0xfffffff0076660d8},

//iOS 12.1.1 - iPhone X
{ "12.1.1", "iPhone10,6", "D221AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,6", "D221AP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1 - iPhone X
{ "12.1", "iPhone10,6", "D221AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,6", "D221AP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0.1 - iPhone X
{ "12.0.1", "iPhone10,6", "D221AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,6", "D221AP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0 - iPhone X
{ "12.0", "iPhone10,6", "D221AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,6", "D221AP", "_kernproc", 0xfffffff00766a0d8},

//iOS 12.1.2 - iPhone 8 Plus
{ "12.1.2", "iPhone10,5", "D211AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,5", "D211AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.2", "iPhone10,5", "D211AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,5", "D211AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1.1 - iPhone 8 Plus
{ "12.1.1", "iPhone10,5", "D211AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,5", "D211AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.1", "iPhone10,5", "D211AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,5", "D211AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1 - iPhone 8 Plus
{ "12.1", "iPhone10,5", "D211AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,5", "D211AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.1", "iPhone10,5", "D211AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,5", "D211AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0.1 - iPhone 8 Plus
{ "12.0.1", "iPhone10,5", "D211AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,5", "D211AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0.1", "iPhone10,5", "D211AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,5", "D211AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0 - iPhone 8 Plus
{ "12.0", "iPhone10,5", "D211AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,5", "D211AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0", "iPhone10,5", "D211AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,5", "D211AAP", "_kernproc", 0xfffffff00766a0d8},


//iOS 12.1.2 - iPhone 8
{ "12.1.2", "iPhone10,4", "D201AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,4", "D201AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.2", "iPhone10,4", "D201AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,4", "D201AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1.1 - iPhone 8
{ "12.1.1", "iPhone10,4", "D201AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,4", "D201AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.1", "iPhone10,4", "D201AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,4", "D201AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.0.1 - iPhone 8
{ "12.0.1", "iPhone10,4", "D201AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,4", "D201AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0.1", "iPhone10,4", "D201AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,4", "D201AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0 - iPhone 8
{ "12.0", "iPhone10,4", "D201AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,4", "D201AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0", "iPhone10,4", "D201AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,4", "D201AAP", "_kernproc", 0xfffffff00766a0d8},


//iOS 12.1.2 - iPhone X
{ "12.1.2", "iPhone10,3", "D22AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,3", "D22AP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1.1 - iPhone X
{ "12.1.1", "iPhone10,3", "D22AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,3", "D22AP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1 - iPhone X
{ "12.1", "iPhone10,3", "D22AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,3", "D22AP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0.1 - iPhone X
{ "12.0.1", "iPhone10,3", "D22AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,3", "D22AP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0 - iPhone X
{ "12.0", "iPhone10,3", "D22AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,3", "D22AP", "_kernproc", 0xfffffff00766a0d8},


//iOS 12.1.2 - iPhone 8 Plus
{ "12.1.2", "iPhone10,2", "D21AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,2", "D21AP", "_kernproc", 0xfffffff0076660d8},

{ "12.1.2", "iPhone10,2", "D21AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,2", "D21AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1.1 - iPhone 8 Plus
{ "12.1.1", "iPhone10,2", "D21AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,2", "D21AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.1", "iPhone10,2", "D21AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,2", "D21AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1 - iPhone 8 Plus
{ "12.1", "iPhone10,2", "D21AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,2", "D21AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.1", "iPhone10,2", "D21AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,2", "D21AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0.1 - iPhone 8 Plus
{ "12.0.1", "iPhone10,2", "D21AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,2", "D21AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0.1", "iPhone10,2", "D21AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,2", "D21AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0.1 - iPhone 8 Plus
{ "12.0", "iPhone10,2", "D21AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,2", "D21AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0", "iPhone10,2", "D21AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,2", "D21AAP", "_kernproc", 0xfffffff00766a0d8},


//iOS 12.1.2 - iPhone 8
{ "12.1.2", "iPhone10,1", "D20AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,1", "D20AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.2", "iPhone10,1", "D20AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.2", "iPhone10,1", "D20AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1.1 - iPhone 8
{ "12.1.1", "iPhone10,1", "D20AP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,1", "D20AP", "_kernproc", 0xfffffff0076660d8},
{ "12.1.1", "iPhone10,1", "D20AAP", "_rootvnode", 0xfffffff0076660c0},
{ "12.1.1", "iPhone10,1", "D20AAP", "_kernproc", 0xfffffff0076660d8},
//iOS 12.1 - iPhone 8
{ "12.1", "iPhone10,1", "D20AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,1", "D20AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.1", "iPhone10,1", "D20AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone10,1", "D20AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0.1 - iPhone 8
{ "12.0.1", "iPhone10,1", "D20AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,1", "D20AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0.1", "iPhone10,1", "D20AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0.1", "iPhone10,1", "D20AAP", "_kernproc", 0xfffffff00766a0d8},
//iOS 12.0 - iPhone 8
{ "12.0", "iPhone10,1", "D20AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,1", "D20AP", "_kernproc", 0xfffffff00766a0d8},
{ "12.0", "iPhone10,1", "D20AAP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.0", "iPhone10,1", "D20AAP", "_kernproc", 0xfffffff00766a0d8},


//iOS 12.1.2 - iPhone 7 Plus
{ "12.1.2", "iPhone9,4", "D111AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.2", "iPhone9,4", "D111AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1.1 - iPhone 7 Plus
{ "12.1.1", "iPhone9,4", "D111AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.1", "iPhone9,4", "D111AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1 - iPhone 7 Plus
{ "12.1", "iPhone9,4", "D111AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1", "iPhone9,4", "D111AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0.1 - iPhone 7 Plus
{ "12.0.1", "iPhone9,4", "D111AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0.1", "iPhone9,4", "D111AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0 - iPhone 7 Plus
{ "12.0", "iPhone9,4", "D111AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0", "iPhone9,4", "D111AP", "_kernproc", 0xfffffff0076420d0},


//iOS 12.1.2 - iPhone 7
{ "12.1.2", "iPhone9,3", "D101AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.2", "iPhone9,3", "D101AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1 - iPhone 7
{ "12.1", "iPhone9,3", "D101AP", "_rootvnode", 0xfffffff00766a0c0},
{ "12.1", "iPhone9,3", "D101AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1.1 - iPhone 7
{ "12.1.1", "iPhone9,3", "D101AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.1", "iPhone9,3", "D101AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0.1 - iPhone 7
{ "12.0.1", "iPhone9,3", "D101AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0.1", "iPhone9,3", "D101AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0 - iPhone 7
{ "12.0", "iPhone9,3", "D101AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0", "iPhone9,3", "D101AP", "_kernproc", 0xfffffff0076420d0},


//iOS 12.1.2 - iPhone 7 Plus
{ "12.1.2", "iPhone9,2", "D11AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.2", "iPhone9,2", "D11AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1.1 - iPhone 7 Plus
{ "12.1.1", "iPhone9,2", "D11AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.1", "iPhone9,2", "D11AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1 - iPhone 7 Plus
{ "12.1", "iPhone9,2", "D11AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1", "iPhone9,2", "D11AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0.1 - iPhone 7 Plus
{ "12.0.1", "iPhone9,2", "D11AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0.1", "iPhone9,2", "D11AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0 - iPhone 7 Plus
{ "12.0", "iPhone9,2", "D11AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0", "iPhone9,2", "D11AP", "_kernproc", 0xfffffff0076420d0},


//iOS 12.1.2 - iPhone 7
{ "12.1.2", "iPhone9,1", "D10AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.2", "iPhone9,1", "D10AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1.1 - iPhone 7
{ "12.1.1", "iPhone9,1", "D10AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1.1", "iPhone9,1", "D10AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.1 - iPhone 7
{ "12.1", "iPhone9,1", "D10AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.1", "iPhone9,1", "D10AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0.1 - iPhone 7
{ "12.0.1", "iPhone9,1", "D10AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0.1", "iPhone9,1", "D10AP", "_kernproc", 0xfffffff0076420d0},
//iOS 12.0 - iPhone 7
{ "12.0", "iPhone9,1", "D10AP", "_rootvnode", 0xfffffff0076420b8},
{ "12.0", "iPhone9,1", "D10AP", "_kernproc", 0xfffffff0076420d0},


//iOS 12.1.2 - iPhone SE
{ "12.1.2", "iPhone8,4", "N69AP", "_rootvnode", 0xfffffff0076020b8},
{ "12.1.2", "iPhone8,4", "N69AP", "_kernproc", 0xfffffff0076020d0},
{ "12.1.2", "iPhone8,4", "N69uAP", "_rootvnode", 0xfffffff0076020b8},
{ "12.1.2", "iPhone8,4", "N69uAP", "_kernproc", 0xfffffff0076020d0},
//iOS 12.1.1 - iPhone SE
{ "12.1.1", "iPhone8,4", "N69AP", "_rootvnode", 0xfffffff0076020b8},
{ "12.1.1", "iPhone8,4", "N69AP", "_kernproc", 0xfffffff0076020d0}, 
{ "12.1.1", "iPhone8,4", "N69uAP", "_rootvnode", 0xfffffff0076020b8},
{ "12.1.1", "iPhone8,4", "N69uAP", "_kernproc", 0xfffffff0076020d0}, 
//iOS 12.1 - iPhone SE
{ "12.1", "iPhone8,4", "N69AP", "_rootvnode", 0xfffffff0076020b8}, 
{ "12.1", "iPhone8,4", "N69AP", "_kernproc", 0xfffffff0076020d0},
{ "12.1", "iPhone8,4", "N69uAP", "_rootvnode", 0xfffffff0076020b8}, 
{ "12.1", "iPhone8,4", "N69uAP", "_kernproc", 0xfffffff0076020d0},
//iOS 12.0.1 - iPhone SE
{ "12.0.1", "iPhone8,4", "N69AP", "_rootvnode", 0xfffffff0076020b8},
{ "12.0.1", "iPhone8,4", "N69AP", "_kernproc", 0xfffffff0076020d0},
{ "12.0.1", "iPhone8,4", "N69uAP", "_rootvnode", 0xfffffff0076020b8},
{ "12.0.1", "iPhone8,4", "N69uAP", "_kernproc", 0xfffffff0076020d0},
//iOS 12.0 - iPhone SE
{ "12.0", "iPhone8,4", "N69AP", "_rootvnode", 0xfffffff0076020b8},
{ "12.0", "iPhone8,4", "N69AP", "_kernproc", 0xfffffff0076020d0},
{ "12.0", "iPhone8,4", "N69uAP", "_rootvnode", 0xfffffff0076020b8},
{ "12.0", "iPhone8,4", "N69uAP", "_kernproc", 0xfffffff0076020d0},
```
如果需要支持自己手中的设备，要么直接联系作者添加支持，要么就使用[jtool2](http://newosxbook.com/tools/jtool2.tgz)获取到自己设备对应内核的`_kernproc`函数地址，然后代码中调用`void setKernelSymbol (char *Symbol, uint64_t Address);`来设定符号`_kernproc`。

> And you have debugging again :-)