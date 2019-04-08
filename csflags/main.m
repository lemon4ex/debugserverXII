//
//  main.c
//  csflags
//
//  Created by h4ck on 2019/4/8.
//  Copyright (c) 2019年 ___ORGANIZATIONNAME___. All rights reserved.
//

#include <stdio.h>
#include <Foundation/Foundation.h>
#include <mach/mach_port.h>
#include <mach/kern_return.h>
#include "QiLin.h"

//    http://newosxbook.com/articles/MDGA.html
//    http://newosxbook.com/QiLin/

// Only test on iPhone7(iPhone9,1) + iOS12.0

static void nullFunc(char *a1,...) {}; // suppress debug

int main (int argc, const char * argv[])
{
    setDebugReporter(nullFunc);
    do {
        if (argc < 3) break;
        int pid = atoi(argv[1]);
        int flag = 0;
        int ret = sscanf(argv[2], "0x%x",&flag);
        if (!ret) break;
        mach_port_t    kernel_task_port;
        kern_return_t host_get_special_port(task_t, int node, int which, mach_port_t *);
        kern_return_t kr = host_get_special_port(mach_host_self(), 0, 4, &kernel_task_port);
        if (kr) { fprintf(stderr,"Call host_get_special_port failed!\n"); return kr;}
        NSDictionary *offsets = [NSDictionary dictionaryWithContentsOfFile:@"/jb/offsets.plist"];
        NSString *stringBase = offsets[@"KernelBase"];
        NSString *stringSlide = offsets[@"KernelSlide"];
        NSString *stringTask = offsets[@"KernelTask"];
        NSLog(@"Read offsets from /jb/offsets.plist: \n%@",offsets);
        uint64_t kernel_base = 0;
        uint64_t kernel_slide = 0;
        uint64_t kernel_task = 0;
        ret = sscanf(stringBase.UTF8String, "0x%llx",&kernel_base);
        if (!ret) { fprintf(stderr,"Read kernel base from hex value failed!\n"); return ret;}
        ret = sscanf(stringSlide.UTF8String, "0x%llx",&kernel_slide);
        if (!ret) { fprintf(stderr,"Read kernel slide from hex value failed!\n"); return ret;}
        ret = sscanf(stringTask.UTF8String, "0x%llx",&kernel_task);
        if (!ret) { fprintf(stderr,"Read kernel task from hex value failed!\n"); return ret;}
        printf("Kernel: port 0x%x, task 0x%llx, base 0x%llx, slide 0x%llx\n", kernel_task_port,kernel_task,kernel_base,kernel_slide);
        int rc = initQiLin(kernel_task_port, kernel_base);
        if (rc) { fprintf(stderr,"Qilin Initialization failed!\n"); return rc;}
//        setKernelSymbol("_kernproc", kernel_task);
        ret = setCSFlagsForPid(pid,flag);
        printf("RC: %d\n", ret);
        return 0;
    } while (0);
    fprintf(__stderrp, "Usage: csflags _pid_ 0xflags\nExample: csflags 936 0x4\nYou can find more info: http://newosxbook.com/articles/MDGA.html\n");
    return 1;
}

