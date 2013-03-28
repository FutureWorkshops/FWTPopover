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

    RistrettoTableViewController *rootViewController = [[[RistrettoTableViewController alloc] init] autorelease];
    ViewController *defaultVC = [[[ViewController alloc] init] autorelease];
    ViewController *manyVC = [[[ViewController alloc] init] autorelease];
    manyVC.manyPopoversEnabled = YES;
    
//    NSArray *samples = @[[RistrettoSampleDescriptor descriptorWithTitle:@"Default" className:@"ViewController"],
//                         ];
    NSArray *samples = @[[RistrettoSampleDescriptor descriptorWithTitle:@"Default" instance:defaultVC],
                         [RistrettoSampleDescriptor descriptorWithTitle:@"Custom - Multiples" instance:manyVC],
                         ];
    rootViewController.items = samples;
    rootViewController.title = @"FWTPopover";
    
    //
    UIView *headerView = [[[UIView alloc] initWithFrame:(CGRect){.0f, .0f, 240.0f, 200.0f}] autorelease];
    [rootViewController setTableHeaderView:headerView insets:(UIEdgeInsets){58.0f, 40.0f, 45.0f, 40.0f}];
    
    UIImageView *iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_popover.png"]] autorelease];
    iconView.center = CGPointMake(CGRectGetMidX(headerView.bounds), iconView.center.y);
    [headerView addSubview:iconView];
    
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.text = @"Choose a sample:";
    label.font = [UIFont Ristretto_lightFontOfSize:18.0f];
    label.textColor = [UIColor Ristretto_darkGrayColor];
    [label sizeToFit];
    label.center = CGPointMake(CGRectGetMidX(headerView.bounds), CGRectGetHeight(headerView.bounds)-CGRectGetHeight(label.bounds)*.5f);
    [headerView addSubview:label];
    
    self.window.rootViewController = [UINavigationController Ristretto_navigationControllerWithRootViewController:rootViewController];
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
