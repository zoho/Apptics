//
//  CrashMaster.m
//  AppticsDemo
//
//  Created by Saravanan S on 20/01/22.
//

#import "CrashMaster.h"
#import <pthread.h>
#import <sys/mman.h>

@implementation CrashMaster

@end

@implementation CrashNULL

- (void)crash
{
  volatile char *ptr = NULL;
  (void)*ptr;
}

@end

@implementation CrashGarbage

- (void)crash
{
    void *ptr = mmap(NULL, (size_t)getpagesize(), PROT_NONE, MAP_ANON | MAP_PRIVATE, -1, 0);
    
    if (ptr != MAP_FAILED)
        munmap(ptr, (size_t)getpagesize());
    
#if __i386__
    asm volatile ( "mov %0, %%eax\n\tmov (%%eax), %%eax" : : "X" (ptr) : "memory", "eax" );
#elif __x86_64__
    asm volatile ( "mov %0, %%rax\n\tmov (%%rax), %%rax" : : "X" (ptr) : "memory", "rax" );
#elif __arm__ && __ARM_ARCH == 7
    asm volatile ( "mov r4, %0\n\tldr r4, [r4]" : : "X" (ptr) : "memory", "r4" );
#elif __arm__ && __ARM_ARCH == 6
    asm volatile ( "mov r4, %0\n\tldr r4, [r4]" : : "X" (ptr) : "memory", "r4" );
#elif __arm64__
    asm volatile ( "mov x4, %0\n\tldr x4, [x4]" : : "X" (ptr) : "memory", "x4" );
#endif
}

@end

@implementation CrashAsyncSafeThread

- (void)crash
{
  pthread_getname_np(pthread_self(), ((char *) 0x1), 1);
  
  /* This is unreachable, but prevents clang from applying TCO to the above when
   * optimization is enabled. */
  NSLog(@"I'm here from the tail call prevention department.");
}

@end

@implementation CrashObjCException

- (void)crash __attribute__((noreturn))
{
    @throw [NSException exceptionWithName:NSGenericException reason:@"An uncaught exception! SCREAM."
                        userInfo:@{ NSLocalizedDescriptionKey: @"I'm in your program, catching your exceptions!" }];
}

@end

@implementation CrashReadOnlyPage

static void __attribute__((used)) dummyfunc(void)
{
}

- (void)crash
{
  volatile char *ptr = (char *)dummyfunc;
  *ptr = 0;
}

@end

@implementation CrashAbort

- (void)crash __attribute__((noreturn))
{
    abort();
}

@end
