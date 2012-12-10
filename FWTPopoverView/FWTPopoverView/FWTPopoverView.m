//
//  FWTPopoverHintView.m
//  FWTPopoverHintView
//
//  Created by Marco Meschini on 7/12/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "FWTPopoverView.h"
#import <QuartzCore/QuartzCore.h>

#define FWT_PV_SUGGESTED_EDGE_INSETS                    UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)
#define FWT_PV_CONTENT_SIZE                             CGSizeMake(160.0f, 60.0f)
#define FWT_PV_ADJUST_POSITION_IN_SUPERVIEW_ENABLED     YES

@interface FWTPopoverArrow ()
@property (nonatomic, readwrite, assign) FWTPopoverArrowDirection direction;
@property (nonatomic, readwrite, assign) CGFloat offset;
@end

struct FWTPopoverViewFrameAndArrowAdjustment
{
    CGRect frame;
    CGFloat dx;
    CGFloat dy;
    NSInteger direction;
};

@interface FWTPopoverView ()

@property (nonatomic, retain)  UIImageView *backgroundImageView;
@property (nonatomic, readwrite, retain) UIView *contentView;
@property (nonatomic, assign) UIEdgeInsets suggestedEdgeInsets, edgeInsets;

@end

@implementation FWTPopoverView
@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentView = _contentView;
@synthesize arrow = _arrow;
@synthesize backgroundHelper = _backgroundHelper;
@synthesize animationHelper = _animationHelper;

- (void)dealloc
{
    self.arrow = nil;
    self.backgroundHelper = nil;
    self.animationHelper = nil;
    self.contentView = nil;
    self.backgroundImageView = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {        
        //
        self.suggestedEdgeInsets = FWT_PV_SUGGESTED_EDGE_INSETS;
        self.contentSize = FWT_PV_CONTENT_SIZE;
        self.adjustPositionInSuperviewEnabled = FWT_PV_ADJUST_POSITION_IN_SUPERVIEW_ENABLED;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //
    if (!self.backgroundImageView.superview) [self addSubview:self.backgroundImageView];
    self.backgroundImageView.frame = self.bounds;
    
    //
    if (!self.contentView.superview) [self addSubview:self.contentView]; 
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
}

#pragma mark - Getters
- (UIImageView *)backgroundImageView
{
    if (!self->_backgroundImageView) self->_backgroundImageView = [[UIImageView alloc] init];
    return self->_backgroundImageView;
}

- (UIView *)contentView
{
    if (!self->_contentView) self->_contentView = [[UIView alloc] init];
    return self->_contentView;
}

- (FWTPopoverBackgroundHelper *)backgroundHelper
{
    if (!self->_backgroundHelper) self->_backgroundHelper = [[FWTPopoverBackgroundHelper alloc] initWithAnnotationView:self];
    return self->_backgroundHelper;
}

- (FWTPopoverArrow *)arrow
{
    if (!self->_arrow) self->_arrow = [[FWTPopoverArrow alloc] init];
    return self->_arrow;
}

- (FWTPopoverAnimationHelper *)animationHelper
{
    if (!self->_animationHelper) self->_animationHelper = [[FWTPopoverAnimationHelper alloc] initWithAnnotationView:self];
    return self->_animationHelper;
}

#pragma mark - Private
- (CGFloat)_arrowOffsetForDeltaX:(CGFloat)dX deltaY:(CGFloat)dY direction:(NSInteger)direction
{
    CGRect shapeBounds = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
    CGFloat cornerRadius = self.backgroundHelper.cornerRadius;
    CGSize availableHalfRectSize = CGSizeMake((shapeBounds.size.width-2*cornerRadius)*.5f, (shapeBounds.size.height-2*cornerRadius)*.5f);
    CGFloat maxArrowOffset = .0f;
    CGFloat arrowOffset = .0f;
    if (self.arrow.direction & FWTPopoverArrowDirectionUp || self.arrow.direction & FWTPopoverArrowDirectionDown)
    {
        arrowOffset = direction*dX;
        maxArrowOffset = availableHalfRectSize.width - cornerRadius;
    }
    else if (self.arrow.direction & FWTPopoverArrowDirectionLeft || self.arrow.direction & FWTPopoverArrowDirectionRight)
    {
        arrowOffset = direction*dY;
        maxArrowOffset = availableHalfRectSize.height - cornerRadius;
    }
    
    if (abs(arrowOffset) > maxArrowOffset)
        arrowOffset = (arrowOffset > 0) ? maxArrowOffset : -maxArrowOffset;
    
    return arrowOffset;
}

- (CGPoint)_midPointForRect:(CGRect)rect popoverSize:(CGSize)popoverSize arrowDirection:(FWTPopoverArrowDirection)arrowDirections
{
    CGPoint midPoint = CGPointZero;
    midPoint.x = CGRectGetWidth(rect) == 1.0f ? rect.origin.x : CGRectGetMidX(rect);
    midPoint.y = CGRectGetHeight(rect) == 1.0f ? rect.origin.y : CGRectGetMidY(rect);
    
    if (self.arrow.direction & FWTPopoverArrowDirectionUp)
        midPoint.x -= (popoverSize.width * .5f + self.arrow.cornerOffset + self.arrow.offset);
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionDown)
    {
        midPoint.x -= (popoverSize.width * .5f + self.arrow.cornerOffset + self.arrow.offset);
        midPoint.y -= popoverSize.height;
    }
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionLeft)
        midPoint.y -= (popoverSize.height * .5f + self.arrow.cornerOffset + self.arrow.offset);
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionRight)
    {
        midPoint.x -= popoverSize.width;
        midPoint.y -= (popoverSize.height * .5f + self.arrow.cornerOffset + self.arrow.offset);
    }
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionNone)
    {
        midPoint.x -= popoverSize.width * .5f;
        midPoint.y -= popoverSize.height * .5f;
    }
    
    return midPoint;
}

- (struct FWTPopoverViewFrameAndArrowAdjustment)_adjustmentForFrame:(CGRect)frame inSuperview:(UIView *)view
{
    struct FWTPopoverViewFrameAndArrowAdjustment toReturn;
    toReturn.frame = frame;
    toReturn.dx = .0f;
    toReturn.dy = .0f;
    toReturn.direction = 1;
    
    CGRect intersection = CGRectIntersection(view.bounds, toReturn.frame);    
    CGFloat frameWidth = toReturn.frame.size.width;
    CGFloat frameHeight = toReturn.frame.size.height;
    if (intersection.size.width != frameWidth)
    {
        toReturn.dx = frameWidth-intersection.size.width;
        if (intersection.origin.x == 0)
        {
            toReturn.frame = CGRectOffset(toReturn.frame, toReturn.dx, .0f);
            toReturn.direction = -1;
        }
        else
            toReturn.frame = CGRectOffset(toReturn.frame, -toReturn.dx, .0f);
    }
    if (intersection.size.height != frameHeight)
    {
        toReturn.dy = frameHeight-intersection.size.height;
        if (intersection.origin.y == 0)
        {
            toReturn.frame = CGRectOffset(toReturn.frame, .0f, toReturn.dy);
            toReturn.direction = -1;
        }
        else
            toReturn.frame = CGRectOffset(toReturn.frame, .0f, -toReturn.dy);
    }
    
    return toReturn;
}

#pragma mark - Public
- (void)presentFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirection:(FWTPopoverArrowDirection)arrowDirection animated:(BOOL)animated
{
    //
    self.arrow.direction = arrowDirection;
    
    //
    self.edgeInsets = [self.arrow adjustedEdgeInsetsForEdgeInsets:self.suggestedEdgeInsets];
    
    //TODO: is safe to do in this way??
    CGSize currentSize = self.contentSize;
    currentSize.width += self.edgeInsets.left + self.edgeInsets.right;
    currentSize.height += self.edgeInsets.top + self.edgeInsets.bottom;
    
    //
    CGPoint newOrigin = [self _midPointForRect:rect popoverSize:currentSize arrowDirection:self.arrow.direction];
    CGRect frame = CGRectZero;
    frame.origin = newOrigin;
    frame.size = currentSize;
    frame = CGRectIntegral(frame);
    self.frame = frame;
    if (self.adjustPositionInSuperviewEnabled)
    {
        struct FWTPopoverViewFrameAndArrowAdjustment adj = [self _adjustmentForFrame:frame inSuperview:view];
        self.frame = adj.frame;
        self.arrow.offset = [self _arrowOffsetForDeltaX:adj.dx deltaY:adj.dy direction:adj.direction];
    }
    
    //
    self.backgroundImageView.image = [self.backgroundHelper resizableBackgroundImageForSize:currentSize edgeInsets:self.edgeInsets];
    
    //
    if (!animated)
    {
        [view addSubview:self];
        
        if (self.didPresentBlock) self.didPresentBlock(self);
    }
    else
    {
        //
        [self.animationHelper safePerformBlock:self.animationHelper.prepareBlock];
        
        //
        [view addSubview:self];
          
        //
        if (animated)
            [UIView animateWithDuration:self.animationHelper.presentDuration
                                  delay:self.animationHelper.presentDelay
                                options:self.animationHelper.presentOptions
                             animations:self.animationHelper.presentAnimationsBlock
                             completion:^(BOOL finished) {

                                 [self.animationHelper safePerformCompletionBlock:self.animationHelper.presentCompletionBlock finished:finished];
                                 
                                 if (self.didPresentBlock) self.didPresentBlock(self);
            }];
    }
}

- (void)adjustPositionToRect:(CGRect)rect
{
    [self adjustPositionToRect:rect animated:NO];
}

- (void)adjustPositionToRect:(CGRect)rect animated:(BOOL)animated
{
    __block typeof(self) myself = self;
    void(^adjustPositionBlock)(void) = ^() {
        CGPoint newOrigin = [myself _midPointForRect:rect popoverSize:myself.bounds.size arrowDirection:myself.arrow.direction];
        CGRect frame = myself.frame;
        frame.origin = newOrigin;
        
        if (myself.adjustPositionInSuperviewEnabled)
            frame = [myself _adjustmentForFrame:frame inSuperview:myself.superview].frame;
        
        myself.frame = frame;
    };
    
    if (animated)
        [UIView animateWithDuration:self.animationHelper.adjustPositionDuration animations:adjustPositionBlock];
    else
        adjustPositionBlock();
}

- (void)dismissPopoverAnimated:(BOOL)animated
{
    if (animated)
        [UIView animateWithDuration:self.animationHelper.dismissDuration
                              delay:self.animationHelper.dismissDelay
                            options:self.animationHelper.dismissOptions
                         animations:self.animationHelper.dismissAnimationsBlock
                         completion:^(BOOL finished) {

                             [self.animationHelper safePerformCompletionBlock:self.animationHelper.dismissCompletionBlock finished:finished];
                             
                             [self removeFromSuperview];
                             
                             if (self.didDismissBlock) self.didDismissBlock(self);
                         }];
    else
    {
        [self removeFromSuperview];
        
        if (self.didDismissBlock) self.didDismissBlock(self);
    }
}

- (CGRect)arrowRect
{
    CGRect toReturn = self.frame;
    toReturn.size = self.arrow.size;
    
    if (self.arrow.direction & FWTPopoverArrowDirectionUp)
    {
        toReturn.origin.x += (CGRectGetWidth(self.frame)-self.arrow.size.width)*.5f + self.arrow.offset;
        toReturn.origin.y += self.edgeInsets.top-self.arrow.size.height;
    }
    else if (self.arrow.direction & FWTPopoverArrowDirectionDown)
    {
        toReturn.origin.x += (CGRectGetWidth(self.frame)-self.arrow.size.width)*.5f + self.arrow.offset;
        toReturn.origin.y += (CGRectGetHeight(self.frame)-self.edgeInsets.bottom);
    }
    else if (self.arrow.direction & FWTPopoverArrowDirectionLeft)
    {
        toReturn.origin.y += (CGRectGetHeight(self.frame)-self.arrow.size.width)*.5f + self.arrow.offset;
        toReturn.origin.x += self.suggestedEdgeInsets.left;//-self.arrow.size.width;
        toReturn.size = CGSizeMake(self.arrow.size.height, self.arrow.size.width);
    }
    else if (self.arrow.direction & FWTPopoverArrowDirectionRight)
    {
        toReturn.origin.y += (CGRectGetHeight(self.frame)-self.arrow.size.width)*.5f + self.arrow.offset;
        toReturn.origin.x += (CGRectGetWidth(self.frame)-self.edgeInsets.right);
        toReturn.size = CGSizeMake(self.arrow.size.height, self.arrow.size.width);
    }
    else if (self.arrow.direction & FWTPopoverArrowDirectionNone)
    {
        toReturn = CGRectZero;
    }
    
    return toReturn;
}

@end
