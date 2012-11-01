//
//  FWTAnnotationArrow.m
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 30/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPopoverArrow.h"

@interface FWTPopoverArrow ()
@property (nonatomic, readwrite, assign) FWTPopoverArrowDirection direction;
@end

@implementation FWTPopoverArrow
@synthesize direction = _direction;

- (id)init
{
    if ((self = [super init]))
    {
        self.direction = FWTPopoverArrowDirectionNone;
        self.size = CGSizeMake(10.0f, 10.0f);
        self.offset = .0f;
        self.cornerOffset = .0f;
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
