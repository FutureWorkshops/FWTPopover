//
//  FWTAnnotationBackgroundHelper.h
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 31/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FWTPopoverView, FWTPopoverBackgroundHelper;

typedef void (^FWTAnnotationViewDrawBezierPathBlock)(FWTPopoverBackgroundHelper *, CGContextRef);

@interface FWTPopoverBackgroundHelper : CAShapeLayer

@property (nonatomic, readonly, assign) FWTPopoverView *annotationView;
@property (nonatomic, copy) FWTAnnotationViewDrawBezierPathBlock drawPathBlock;
@property (nonatomic, readonly, assign) CGRect pathFrame;

- (id)initWithAnnotationView:(FWTPopoverView *)annotationView;

- (UIImage *)resizableBackgroundImageForSize:(CGSize)size edgeInsets:(UIEdgeInsets)edgeInsets;

- (UIBezierPath *)bezierPathForRect:(CGRect)rect;

@end
