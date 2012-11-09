//
//  FWTAnnotationArrow.m
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 30/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPopoverArrow.h"

#define FWT_PA_DIRECTION        FWTPopoverArrowDirectionNone
#define FWT_PA_SIZE             CGSizeMake(10.0f, 10.0f)
#define FWT_PA_OFFSET           .0f
#define FWT_PA_CORNER_OFFSET    .0f

@interface FWTPopoverArrow ()
@property (nonatomic, readwrite, assign) FWTPopoverArrowDirection direction;
@property (nonatomic, readwrite, assign) CGFloat offset;
@end

@implementation FWTPopoverArrow
@synthesize direction = _direction;

- (id)init
{
    if ((self = [super init]))
    {
        self.direction = FWT_PA_DIRECTION;
        self.size = FWT_PA_SIZE;
        self.offset = FWT_PA_OFFSET;
        self.cornerOffset = FWT_PA_CORNER_OFFSET;
    }
    return self;
}

- (UIEdgeInsets)adjustedEdgeInsetsForEdgeInsets:(UIEdgeInsets)edgeInsets
{
    UIEdgeInsets adjustedEdgeInsets = edgeInsets;
    CGFloat dY = self.size.height;
    
    if (self.direction & FWTPopoverArrowDirectionUp)
        adjustedEdgeInsets.top += dY;
    else if (self.direction & FWTPopoverArrowDirectionLeft)
        adjustedEdgeInsets.left += dY;
    else if (self.direction & FWTPopoverArrowDirectionRight)
        adjustedEdgeInsets.right += dY;
    else if (self.direction & FWTPopoverArrowDirectionDown)
        adjustedEdgeInsets.bottom += dY;
    
    return adjustedEdgeInsets;
}

@end
