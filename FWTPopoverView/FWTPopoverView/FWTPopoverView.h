//
//  FWTPopoverHintView.h
//  FWTPopoverHintView
//
//  Created by Marco Meschini on 7/12/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FWTPopoverArrow.h"
#import "FWTPopoverBackgroundHelper.h"
#import "FWTPopoverAnimationHelper.h"

@class FWTPopoverView;
@protocol FWTPopoverViewDelegate <NSObject>
@optional
- (void)popoverViewDidPresent:(FWTPopoverView *)annotationView;
- (void)popoverViewDidDismiss:(FWTPopoverView *)annotationView;
@end


@interface FWTPopoverView : UIView

@property (nonatomic, readonly, retain) UIView *contentView;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) BOOL adjustPositionInSuperviewEnabled;

@property (nonatomic, retain) FWTPopoverBackgroundHelper *backgroundHelper;
@property (nonatomic, retain) FWTPopoverArrow *arrow;
@property (nonatomic, retain) FWTPopoverAnimationHelper *animationHelper;

@property (nonatomic, assign) id<FWTPopoverViewDelegate> delegate;

//
- (void)presentFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirection:(FWTPopoverArrowDirection)arrowDirection animated:(BOOL)animated;

//
- (void)dismissPopoverAnimated:(BOOL)animated;

@end
