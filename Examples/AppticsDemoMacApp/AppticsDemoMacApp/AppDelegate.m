//
//  AppDelegate.m
//  AppticsDemoMacApp
//
//  Created by temp on 30/06/22.
//

#import "AppDelegate.h"
#import <Apptics/Apptics.h>


@interface AppDelegate ()


@end

@implementation AppDelegate
- (void)applicationWillFinishLaunching:(NSNotification *)notification{
    
    AppticsConfig.defaultConfig.anonymousType = APAnonymousTypePseudoAnonymous;
    AppticsConfig.defaultConfig.trackOnByDefault = true;
    AppticsConfig.defaultConfig.sendDataOnMobileNetworkByDefault = true;
    [Apptics initializeWithVerbose:true];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
