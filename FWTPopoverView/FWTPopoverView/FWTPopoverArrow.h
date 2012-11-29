//
//  FWTAnnotationArrow.h
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 30/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FWTPopoverArrowDirection) {
    FWTPopoverArrowDirectionNone = 1UL << 0,
    FWTPopoverArrowDirectionUp = 1UL << 1,
    FWTPopoverArrowDirectionDown = 1UL << 2,
    FWTPopoverArrowDirectionLeft = 1UL << 3,
    FWTPopoverArrowDirectionRight = 1UL << 4,
};

@interface FWTPopoverArrow : NSObject

@property (nonatomic, readonly, assign) FWTPopoverArrowDirection direction;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, readonly, assign) CGFloat offset;
@property (nonatomic, assign) CGFloat cornerOffset;

- (UIEdgeInsets)adjustedEdgeInsetsForEdgeInsets:(UIEdgeInsets)edgeInsets;

@end
