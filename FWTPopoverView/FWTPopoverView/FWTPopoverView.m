//
//  FWTPopoverHintView.m
//  FWTPopoverHintView
//
//  Created by Marco Meschini on 7/12/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "FWTPopoverView.h"
#import <QuartzCore/QuartzCore.h>

@interface FWTPopoverArrow ()
@property (nonatomic, readwrite, assign) FWTPopoverArrowDirection direction;
@end

@interface FWTPopoverView ()
{
    struct
    {
        BOOL didPresent: 1;
        BOOL didDismiss: 1;
    } _delegateHas;
}

@property (nonatomic, retain)  UIImageView *backgroundImageView;
@property (nonatomic, readwrite, retain) UIView *contentView;
@property (nonatomic, assign) UIEdgeInsets suggestedEdgeInsets, edgeInsets;

//  Private
- (CGFloat)_arrowOffsetForDeltaX:(CGFloat)dX deltaY:(CGFloat)dY direction:(NSInteger)direction;
- (CGPoint)_midPointForRect:(CGRect)rect popoverSize:(CGSize)popoverSize arrowDirection:(FWTPopoverArrowDirection)arrowDirections;
- (void)_adjustAndSetFrame:(CGRect)frame inSuperview:(UIView *)view;

@end

@implementation FWTPopoverView
@synthesize backgroundImageView = _backgroundImageView;
@synthesize contentView = _contentView;
@synthesize delegate = _delegate;
@synthesize arrow = _arrow;
@synthesize backgroundHelper = _backgroundHelper;
@synthesize animationHelper = _animationHelper;

- (void)dealloc
{
    self.delegate = nil;
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
        self.suggestedEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        self.contentSize = CGSizeMake(160.0f, 60.0f);
        self.adjustPositionInSuperviewEnabled = YES;
        
        //  debug
//        self.contentView.layer.borderWidth = 1.0f;
//        self.contentView.layer.borderColor = [[UIColor redColor] colorWithAlphaComponent:.25f].CGColor;
//        self.backgroundImageView.layer.borderWidth = 2.0f;
        self.layer.borderWidth = 1.0f;
    }
    
    return self;
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    NSLog(@"setFramE:%@", NSStringFromCGRect(frame));
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"layoutSubviews");
    
    //
    if (!self.backgroundImageView.superview)
        [self addSubview:self.backgroundImageView];

    self.backgroundImageView.frame = self.bounds;
    
    //
    if (!self.contentView.superview)
        [self addSubview:self.contentView];
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets);
}

#pragma mark - Getters
- (UIImageView *)backgroundImageView
{
    if (!self->_backgroundImageView)
        self->_backgroundImageView = [[UIImageView alloc] init];
    
    return self->_backgroundImageView;
}

- (UIView *)contentView
{
    if (!self->_contentView)
        self->_contentView = [[UIView alloc] init];
    
    return self->_contentView;
}

- (FWTPopoverBackgroundHelper *)backgroundHelper
{
    if (!self->_backgroundHelper)
        self->_backgroundHelper = [[FWTPopoverBackgroundHelper alloc] initWithAnnotationView:self];
    
    return self->_backgroundHelper;
}

- (FWTPopoverArrow *)arrow
{
    if (!self->_arrow)
        self->_arrow = [[FWTPopoverArrow alloc] init];
    
    return self->_arrow;
}

- (FWTPopoverAnimationHelper *)animationHelper
{
    if (!self->_animationHelper)
        self->_animationHelper = [[FWTPopoverAnimationHelper alloc] initWithAnnotationView:self];
    
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
    
//    CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    if (self.arrow.direction & FWTPopoverArrowDirectionUp)
        midPoint.x -= (popoverSize.width * .5f + self.arrow.cornerOffset);
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionDown)
    {
        midPoint.x -= (popoverSize.width * .5f + self.arrow.cornerOffset);
        midPoint.y -= popoverSize.height;
    }
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionLeft)
        midPoint.y -= (popoverSize.height * .5f + self.arrow.cornerOffset);
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionRight)
    {
        midPoint.x -= popoverSize.width;
        midPoint.y -= (popoverSize.height * .5f + self.arrow.cornerOffset);
    }
    
    else if (self.arrow.direction & FWTPopoverArrowDirectionNone)
    {
        midPoint.x -= popoverSize.width * .5f;
        midPoint.y -= popoverSize.height * .5f;
    }
    
    return midPoint;
}

- (void)_adjustAndSetFrame:(CGRect)frame inSuperview:(UIView *)view
{
    CGFloat dX = .0f;
    CGFloat dY = .0f;
    NSInteger direction = 1;
    if (self.adjustPositionInSuperviewEnabled)
    {
        CGRect intersection = CGRectIntersection(view.bounds, frame);

        CGFloat frameWidth = frame.size.width;
        CGFloat frameHeight = frame.size.height;
        if (intersection.size.width != frameWidth)
        {
            dX = frameWidth-intersection.size.width;
            if (intersection.origin.x == 0)
            {
                frame = CGRectOffset(frame, dX, .0f);
                direction = -1;
            }
            else
                frame = CGRectOffset(frame, -dX, .0f);
        }
        if (intersection.size.height != frameHeight)
        {
            dY = frameHeight-intersection.size.height;
            if (intersection.origin.y == 0)
            {
                frame = CGRectOffset(frame, .0f, dY);
                direction = -1;
            }
            else
                frame = CGRectOffset(frame, .0f, -dY);
        }
    }
    
    //
    self.frame = CGRectIntegral(frame);
    
    //
    if (self.adjustPositionInSuperviewEnabled)
        self.arrow.offset = [self _arrowOffsetForDeltaX:dX deltaY:dY direction:direction];
}

#pragma mark - Public
- (void)setDelegate:(id<FWTPopoverViewDelegate>)delegate
{
    if (self->_delegate != delegate)
    {
        self->_delegate = delegate;
        _delegateHas.didPresent = [self->_delegate respondsToSelector:@selector(popoverViewDidPresent:)];
        _delegateHas.didDismiss = [self->_delegate respondsToSelector:@selector(popoverViewDidDismiss:)];
    }
}

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
    CGPoint midPoint = [self _midPointForRect:rect popoverSize:currentSize arrowDirection:self.arrow.direction];
    CGRect frame = CGRectZero;
    frame.origin = midPoint;
    frame.size = currentSize;
    [self _adjustAndSetFrame:frame inSuperview:view];
        
    //
    self.backgroundImageView.image = [self.backgroundHelper resizableBackgroundImageForSize:currentSize edgeInsets:self.edgeInsets];

    //
    if (!animated)
    {
        [view addSubview:self];
        
        if (_delegateHas.didPresent) [self.delegate popoverViewDidPresent:self];
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

                                 //
                                 [self.animationHelper safePerformCompletionBlock:self.animationHelper.presentCompletionBlock finished:finished];
                                 
                                 //
                                 if (_delegateHas.didPresent) [self.delegate popoverViewDidPresent:self];
            }];
    }
}

- (void)adjustPositionToRect:(CGRect)rect
{
    CGPoint p = [self _midPointForRect:rect popoverSize:self.bounds.size arrowDirection:self.arrow.direction];
    CGRect frame = self.frame;
    frame.origin = p;
    self.frame = frame;
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
                             
                             if (_delegateHas.didDismiss) [self.delegate popoverViewDidDismiss:self];
                         }];
    else
    {
        [self removeFromSuperview];
        
        if (_delegateHas.didDismiss) [self.delegate popoverViewDidDismiss:self];
    }
}

@end
