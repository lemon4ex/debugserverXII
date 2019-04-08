//
//  main.m
//  debugserverXII
//
//  Created by h4ck on 2019/4/8.
//  Copyright (c) 2019年 h4ck. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#include <mach/mach_port.h>
#include <mach/kern_return.h>
#include "QiLin.h"
#include <unistd.h>
#include <spawn.h>
#include <sys/types.h>
#include <sys/stat.h>

extern char **environ;

static void nullFunc(char *a1,...) {}; // suppress debug

static int isInt(char* str)
{
    for(int i=0; i < strlen(str); i++)
    {
        if(!(isdigit(str[i]))) return 0;
    }
    return 1;
}


int main (int argc, const char * argv[])
{
    setDebugReporter(nullFunc);
    pid_t pid = 0;
    char *target = NULL;
    for (int i = 0; i < argc; i++) {
        if (strcmp(argv[i], "-a") == 0 && i + 1 < argc) {
            target = strdup(argv[i+1]);
            break;
        }
    }
    
    if (isInt(target)) {
        pid = atoi(target);
    }
    else{
        pid = findPidOfProcess(target);
    }
    free(target);
    if (pid <= 0) {
        fprintf(stderr,"[-] Get process pid failed!\n");
        return pid;
    }
    
    int ret = 0;
    mach_port_t    kernel_task_port;
    kern_return_t host_get_special_port(task_t, int node, int which, mach_port_t *);
    kern_return_t kr = host_get_special_port(mach_host_self(), 0, 4, &kernel_task_port);
    if (kr) {
        fprintf(stderr,"[-] Call host_get_special_port failed!\n");
        return kr;
    }
    NSDictionary *offsets = [NSDictionary dictionaryWithContentsOfFile:@"/jb/offsets.plist"];
    NSString *stringBase = offsets[@"KernelBase"];

    printf("[+] Read offsets from /jb/offsets.plist\n");
    uint64_t kernel_base = 0;

    ret = sscanf(stringBase.UTF8String, "0x%llx",&kernel_base);
    if (!ret) {
        fprintf(stderr,"[-] Read kernel base from hex value failed!\n");
        return ret;
    }
    
    printf("[+] Kernel: port 0x%x, base 0x%llx\n", kernel_task_port,kernel_base);
    int rc = initQiLin(kernel_task_port, kernel_base);
    if (rc) { fprintf(stderr,"[-] Qilin Initialization failed!\n"); return rc;}
    
    // if you want to support your device, please uncomment next line
//    setKernelSymbol("_kernproc", kernel_task);
    
    ret = setCSFlagsForPid(pid,0x4);
    if (ret) {
        fprintf(stderr,"[-] Call setCSFlagsForPid failed!\n");
        return ret;
    }
    
    // real path of debugserver, /usr/local/bin/debugserver is a shell script tool
    char *server_path = "/usr/bin/debugserver";
    chmod(server_path,0x1FF);
    ret = access(server_path, 1);
    if (ret)
    {
        printf("[-] Can't execute %s",server_path);
        ret = access(server_path, 0);
        if ( ret )
            fprintf(stderr, ", Doesn't even exist\n");
        else
            fprintf(stderr, "\n");
        return ret;
    }
    
    // make a argv string
    size_t argc_len = strlen(server_path);
    for (int i = 1; i < argc; i++) {
        argc_len += strlen(argv[i]);
        argc_len += 1;
    }
    char *fork_cmd = calloc(argc_len + 1, 1);
    memset(fork_cmd, 0, argc_len + 1);
    strcpy(fork_cmd, server_path);
    for (int i = 1; i < argc; i++) {
        strcat(fork_cmd, " ");
        strcat(fork_cmd, argv[i]);
    }
    printf("[+] Execute %s\n",fork_cmd);
    
    // Execute
    pid_t fork_pid;
    int fork_status;
    const char *fork_argv[] = {"sh", "-c", fork_cmd, NULL};
    posix_spawn(&fork_pid, "/bin/sh", NULL, NULL, (char * const *)fork_argv, environ);
    waitpid(fork_pid, &fork_status, WEXITED);
    free(fork_cmd);
    return fork_status;
}

