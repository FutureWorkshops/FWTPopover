//
//  AppDelegate.m
//  FWTPopoverView_Test
//
//  Created by Marco Meschini on 31/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    UIViewController *vc = [[[ViewController alloc] init] autorelease];
    self.window.rootViewController = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
