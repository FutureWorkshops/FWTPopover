//
//  FWTAnnotationBackgroundHelper.m
//  FWTAnnotationManager
//
//  Created by Marco Meschini on 31/10/2012.
//  Copyright (c) 2012 Marco Meschini. All rights reserved.
//

#import "FWTPopoverBackgroundHelper.h"
#import "FWTPopoverView.h"

#define FWT_PBH_CORNER_RADIUS       6.0f
#define FWT_PBH_FILL_COLOR          [[UIColor blackColor] colorWithAlphaComponent:.5f].CGColor
#define FWT_PBH_STROKE_COLOR        [UIColor blackColor].CGColor
#define FWT_PBH_LINE_WIDTH          1.0f
#define FWT_PBH_LINE_JOIN           kCALineJoinRound
#define FWT_PBH_SHADOW_RADIUS       5.0f
#define FWT_PBH_SHADOW_OFFSET       CGSizeMake(.0f, 1.0f)
#define FWT_PBH_SHADOW_COLOR        [[UIColor blackColor] colorWithAlphaComponent:.5f].CGColor
#define FWT_PBH_SHADOW_OPACITY      1.0f

enum {
    AxisTypeHorizontal = 0,
    AxisTypeVertical,
};
typedef NSUInteger AxisType;

@interface FWTPopoverBackgroundHelper ()
@property (nonatomic, readwrite, assign) FWTPopoverView *annotationView;
@property (nonatomic, readwrite, assign) CGRect pathFrame;
@end

@implementation FWTPopoverBackgroundHelper

- (void)dealloc
{
    self.annotationView = nil;
    [super dealloc];
}

- (id)initWithAnnotationView:(FWTPopoverView *)annotationView
{
    if ((self = [super init]))
    {
        self.annotationView = annotationView;
        
        //
        self.cornerRadius = FWT_PBH_CORNER_RADIUS;
        
        //
        self.fillColor = FWT_PBH_FILL_COLOR;
        self.strokeColor = FWT_PBH_STROKE_COLOR;
        
        //
        self.lineWidth = FWT_PBH_LINE_WIDTH;
        self.lineJoin = FWT_PBH_LINE_JOIN;
        
        //
        self.shadowRadius = FWT_PBH_SHADOW_RADIUS;
        self.shadowOffset = FWT_PBH_SHADOW_OFFSET;
        self.shadowColor = FWT_PBH_SHADOW_COLOR;
        self.shadowOpacity = FWT_PBH_SHADOW_OPACITY;
    }
    
    return self;
}

- (UIImage *)resizableBackgroundImageForSize:(CGSize)size edgeInsets:(UIEdgeInsets)edgeInsets
{
    //
    FWTPopoverArrowDirection arrowDirection = self.annotationView.arrow.direction;
    UIEdgeInsets capInsets = UIEdgeInsetsZero;
    CGSize contextSize = size;
    if (arrowDirection & FWTPopoverArrowDirectionUp || arrowDirection & FWTPopoverArrowDirectionDown)
    {
        contextSize.height = (self.cornerRadius * 2) + edgeInsets.top + edgeInsets.bottom + 1.0f;
        capInsets = UIEdgeInsetsMake(edgeInsets.top + self.cornerRadius, .0f, edgeInsets.bottom + self.cornerRadius, .0f);
    }
    else if (arrowDirection & FWTPopoverArrowDirectionLeft || arrowDirection & FWTPopoverArrowDirectionRight)
    {
        contextSize.width = (self.cornerRadius * 2) + edgeInsets.left + edgeInsets.right + 1.0f;
        capInsets = UIEdgeInsetsMake(.0f, edgeInsets.left + self.cornerRadius, .0f, edgeInsets.right + self.cornerRadius);
    }
    else if (arrowDirection & FWTPopoverArrowDirectionNone)
    {
        contextSize.width = (self.cornerRadius * 2) + edgeInsets.left + edgeInsets.right + 1.0f;
        contextSize.height = (self.cornerRadius * 2) + edgeInsets.top + edgeInsets.bottom + 1.0f;
        capInsets = UIEdgeInsetsMake(edgeInsets.top + self.cornerRadius, edgeInsets.left + self.cornerRadius, edgeInsets.bottom + self.cornerRadius, edgeInsets.right + self.cornerRadius);
    }

    //
    CGRect rect = CGRectMake(.0f, .0f, contextSize.width, contextSize.height);
    self.pathFrame = UIEdgeInsetsInsetRect(rect, edgeInsets);
    self.path = [self bezierPathForRect:self.pathFrame].CGPath;
    
    //
    UIImage *image = [self _backgroundImageForSize:contextSize];
    return [image resizableImageWithCapInsets:capInsets];
}

- (UIBezierPath *)bezierPathForRect:(CGRect)rect
{
    CGFloat radius = self.cornerRadius;
    
    //
    //  ab  b           c   cd
    //  a                   d
    //  h                   e
    //  gh  g           f   ef
    //
    CGPoint a  = CGPointMake(rect.origin.x, rect.origin.y + radius);
    CGPoint ab = CGPointMake(a.x, a.y - radius);
    CGPoint b  = CGPointMake(a.x + radius, a.y - radius);
    CGPoint c  = CGPointMake(a.x + rect.size.width - radius, rect.origin.y);
    CGPoint cd = CGPointMake(c.x + radius, c.y);
    CGPoint d  = CGPointMake(c.x + radius, c.y + radius);
    CGPoint e  = CGPointMake(a.x + rect.size.width, rect.origin.y + rect.size.height - radius);
    CGPoint ef = CGPointMake(e.x, e.y + radius);
    CGPoint f  = CGPointMake(e.x - radius, e.y + radius);
    CGPoint g  = CGPointMake(a.x + radius, rect.origin.y + rect.size.height);
    CGPoint gh = CGPointMake(g.x - radius, g.y);
    CGPoint h  = CGPointMake(g.x - radius, g.y - radius);
    
    FWTPopoverArrowDirection arrowDirection = self.annotationView.arrow.direction;
    CGSize arrowSize = self.annotationView.arrow.size;
    CGFloat halfArrowWidth = arrowSize.width*.5f;
    CGSize availableHalfRectSize = CGSizeMake((rect.size.width-2*radius)*.5f, (rect.size.height-2*radius)*.5f);
    CGFloat ao = self.annotationView.arrow.offset;
    CGFloat ao_aco = self.annotationView.arrow.offset + self.annotationView.arrow.cornerOffset;
    void(^AppendArrowBlock)(UIBezierPath *, CGPoint, NSInteger, AxisType) = ^(UIBezierPath *bezierPath, CGPoint point, NSInteger sign, AxisType axisType) {
        
        CGPoint a0, a1, a2;
        if (axisType == AxisTypeHorizontal)
        {
            a0 = CGPointMake(point.x + sign*(availableHalfRectSize.width - halfArrowWidth) + ao, point.y);
            a1 = CGPointMake(point.x + sign*(availableHalfRectSize.width) + ao_aco, point.y - sign*(arrowSize.height));
            a2 = CGPointMake(point.x + sign*(availableHalfRectSize.width + halfArrowWidth) + ao, point.y);
        }
        else
        {
            a0 = CGPointMake(point.x, point.y + sign*(availableHalfRectSize.height - halfArrowWidth) + ao);
            a1 = CGPointMake(point.x + sign*(arrowSize.height), point.y + sign*(availableHalfRectSize.height) + ao_aco);
            a2 = CGPointMake(point.x, point.y + sign*(availableHalfRectSize.height + halfArrowWidth) + ao);
        }
        
        [bezierPath addLineToPoint:a0];
        [bezierPath addLineToPoint:a1];
        [bezierPath addLineToPoint:a2];
    };
    
    //
    UIBezierPath *bp = [UIBezierPath bezierPath];
    [bp moveToPoint:a];
    [bp addQuadCurveToPoint:b controlPoint:ab];
    if (arrowDirection == FWTPopoverArrowDirectionUp)
        AppendArrowBlock(bp, b, 1, AxisTypeHorizontal);
    [bp addLineToPoint:c];
    [bp addQuadCurveToPoint:d controlPoint:cd];
    if (arrowDirection == FWTPopoverArrowDirectionRight)
        AppendArrowBlock(bp, d, 1, AxisTypeVertical);
    [bp addLineToPoint:e];
    [bp addQuadCurveToPoint:f controlPoint:ef];
    if (arrowDirection == FWTPopoverArrowDirectionDown)
        AppendArrowBlock(bp, f, -1, AxisTypeHorizontal);
    [bp addLineToPoint:g];
    [bp addQuadCurveToPoint:h controlPoint:gh];
    if (arrowDirection == FWTPopoverArrowDirectionLeft)
        AppendArrowBlock(bp, h, -1, AxisTypeVertical);
    [bp closePath];
    
    return bp;
}

#pragma mark - Private
- (UIImage *)_backgroundImageForSize:(CGSize)size
{
    //
    self.frame = CGRectMake(.0f, .0f, size.width, size.height);
    
    //
    UIGraphicsBeginImageContextWithOptions(size, NO, .0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //
    CGFloat savedLineWidth = self.lineWidth;
    CGColorRef savedFillColorRef = self.fillColor;
    CGFloat savedShadowOpacity = self.shadowOpacity;
    
    //  render the shadow at first
    if (self.shadowOpacity != .0f)
    {
        self.lineWidth = .0f;                           //  hide stroke
        self.fillColor = [UIColor blackColor].CGColor;  //  use a solid fill color
        [self renderInContext:ctx];
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, self.path);
        CGContextClip(ctx);
        CGContextClearRect(ctx, CGContextGetClipBoundingBox(ctx));
        CGContextRestoreGState(ctx);
    }
    
    //  render the fill without shadow
    self.fillColor = savedFillColorRef;
    self.shadowOpacity = .0f;
    [self renderInContext:ctx];
    
    //  give a chanche to do some extra stuff
    if (self.drawPathBlock)
        self.drawPathBlock(ctx, self);
    
    //  render the border
    self.lineWidth = savedLineWidth;
    self.fillColor = [UIColor clearColor].CGColor;
    [self renderInContext:ctx];
    
    //  restore properties
    self.fillColor = savedFillColorRef;
    self.shadowOpacity = savedShadowOpacity;
    
    //
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
