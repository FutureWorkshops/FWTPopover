//
//  FWTAnnotationAnimationHelper.h
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 31/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWTPopoverView;
typedef void (^FWTAnnotationAnimationPrepareBlock)(void);
typedef void (^FWTAnnotationAnimationChangesBlock)(void);
typedef void (^FWTAnnotationAnimationCompletionBlock)(BOOL finished);

@interface FWTPopoverAnimationHelper : NSObject

@property (nonatomic, readonly, assign) FWTPopoverView *annotationView;
@property (nonatomic, assign) CGFloat presentDuration, dismissDuration;
@property (nonatomic, assign) CGFloat presentDelay, dismissDelay;
@property (nonatomic, assign) UIViewAnimationOptions presentOptions, dismissOptions;
@property (nonatomic, copy) FWTAnnotationAnimationPrepareBlock prepareBlock;
@property (nonatomic, copy) FWTAnnotationAnimationChangesBlock presentAnimationsBlock, dismissAnimationsBlock;
@property (nonatomic, copy) FWTAnnotationAnimationCompletionBlock presentCompletionBlock, dismissCompletionBlock;

- (id)initWithAnnotationView:(FWTPopoverView *)annotationView;

- (void)safePerformBlock:(void (^)(void))block;
- (void)safePerformCompletionBlock:(void (^)(BOOL finished))block finished:(BOOL)finished;

@end
