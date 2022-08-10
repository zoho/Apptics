//
//  CrashMaster.m
//  AppticsDemo
//
//  Created by Saravanan S on 20/01/22.
//

#import "NonFatalMaster.h"
#import <Apptics/Apptics.h>
#import <pthread.h>
#import <sys/mman.h>

@implementation NonFatalMasterObjc

- (void)throwException{
    
    NSArray *crew = [NSArray arrayWithObjects:
                             @"Dave",
                             @"Heywood",
                             @"Frank", nil];
    @try {
        NSLog(@"%@", [crew objectAtIndex:10]);
    }
    @catch (NSException *exception) {
        NSLog(@"Caught an exception");
        APTrackException(exception);
    }
    @finally {
        NSLog(@"Cleaning up");
    }
    
}

- (void)throwError{
    // Generate the desired file path.
    NSString *filename = @"SomeContent.txt";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                         NSDesktopDirectory, NSUserDomainMask, YES
                     );
    NSString *desktopDir = [paths objectAtIndex:0];
    NSString *path = [desktopDir
                      stringByAppendingPathComponent:filename];

    // Try to load the file.
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:path
                         encoding:NSUTF8StringEncoding
                         error:&error];

    // Check if it worked.
    if (content == nil) {
        // Some kind of error occurred.
        APTrackError(error);
    }
}

@end
