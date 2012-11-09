//
//  FWTAnnotationAnimationHelper.m
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 31/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPopoverAnimationHelper.h"
#import "FWTPopoverView.h"

#define FWT_PAH_PRESENT_DURATION            .25f
#define FWT_PAH_DISMISS_DURATION            .25f
#define FWT_PAH_ADJUST_POSITION_DURATION    .25f
#define FWT_PAH_PRESENT_DELAY               .0f
#define FWT_PAH_DISMISS_DELAY               .0f
#define FWT_PAH_PRESENT_OPTIONS             UIViewAnimationOptionCurveEaseIn
#define FWT_PAH_DISMISS_OPTIONS             UIViewAnimationOptionCurveEaseIn

@interface FWTPopoverAnimationHelper ()
@property (nonatomic, readwrite, assign) FWTPopoverView *annotationView;
@end

@implementation FWTPopoverAnimationHelper

- (void)dealloc
{
    self.prepareBlock = nil;
    self.presentAnimationsBlock = nil;
    self.dismissAnimationsBlock = nil;
    self.presentCompletionBlock = nil;
    self.dismissCompletionBlock = nil;
    self.annotationView = nil;
    [super dealloc];
}

- (id)initWithAnnotationView:(FWTPopoverView *)annotationView
{
    if ((self = [super init]))
    {
        self.annotationView = annotationView;
        self.presentDuration = FWT_PAH_PRESENT_DURATION;
        self.dismissDuration = FWT_PAH_DISMISS_DURATION;
        self.adjustPositionDuration = FWT_PAH_ADJUST_POSITION_DURATION;
        self.presentDelay = FWT_PAH_PRESENT_DELAY;
        self.dismissDelay = FWT_PAH_DISMISS_DELAY;
        self.presentOptions = FWT_PAH_PRESENT_OPTIONS;
        self.dismissOptions = FWT_PAH_DISMISS_OPTIONS;
        
        __block typeof(self.annotationView) theAnnotationView = self.annotationView;
        self.prepareBlock = ^{ theAnnotationView.alpha = .0f; };
        self.presentAnimationsBlock = ^{ theAnnotationView.alpha = 1.0f; };
        self.presentCompletionBlock = nil;
        self.dismissAnimationsBlock = ^{ theAnnotationView.alpha = .0f; };
        self.dismissCompletionBlock = nil;
    }
    
    return self;
}

- (void)safePerformBlock:(void (^)(void))block
{
    if (block) block();
}

- (void)safePerformCompletionBlock:(void (^)(BOOL finished))block finished:(BOOL)finished;
{
    if (block) block(finished);
}

@end
