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
    self.window.backgroundColor = [UIColor whiteColor];

    ViewController *defaultVC = [[[ViewController alloc] init] autorelease];
    ViewController *manyVC = [[[ViewController alloc] init] autorelease];
    manyVC.manyPopoversEnabled = YES;
    
    NSArray *samples = @[[RistrettoSampleDescriptor descriptorWithTitle:@"Default" instance:defaultVC],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"Custom - Multiples" instance:manyVC],
                         ];
    
    RistrettoTableViewController *rootViewController = [[[RistrettoTableViewController alloc] init] autorelease];
    rootViewController.items = samples;
    self.window.rootViewController = [UINavigationController Ristretto_navigationControllerWithRootViewController:rootViewController
                                                                                             defaultHeaderEnabled:YES];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
