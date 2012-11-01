//
//  ViewController.m
//  FWTPopoverHintView_Test
//
//  Created by Marco Meschini on 8/6/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "ViewController.h"
#import "FWTPopoverView.h"

@interface ViewController ()
{
    FWTPopoverView *_popoverView;
    UIView *_touchPointView;
    
    UISegmentedControl *_segmentedControl;
    FWTPopoverArrowDirection _popoverArrowDirection;
}

@property (nonatomic, retain) FWTPopoverView *popoverView;
@property (nonatomic, retain) UIView *touchPointView;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, assign) FWTPopoverArrowDirection popoverArrowDirection;

@end

@implementation ViewController
@synthesize popoverView = _popoverView;
@synthesize segmentedControl = _segmentedControl;
@synthesize popoverArrowDirection = _popoverArrowDirection;
@synthesize touchPointView = _touchPointView;

- (void)dealloc
{
    self.touchPointView = nil;
    self.popoverView = nil;
    self.segmentedControl = nil;
    [super dealloc];
}

- (void)loadView
{
    [super loadView];
    
    //
    self.popoverArrowDirection = pow(2, 0);
    
    //
    self.navigationItem.titleView = self.segmentedControl;
    self.segmentedControl.selectedSegmentIndex = 0;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

#pragma mark - Getters
- (UISegmentedControl *)segmentedControl
{
    if (!self->_segmentedControl)
    {
        NSArray *items = @[@"N", @"U", @"D", @"L", @"R"];
        self->_segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        self->_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        self->_segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self->_segmentedControl addTarget:self action:@selector(valueChangedForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
        [self->_segmentedControl sizeToFit];
    }
    
    return self->_segmentedControl;
}

- (FWTPopoverView *)popoverView
{
    if (!self->_popoverView)
    {
        self->_popoverView = [[FWTPopoverView alloc] init];      
        self->_popoverView.animationHelper.dismissCompletionBlock = ^(BOOL finished){
            self.popoverView = nil;
        };
    }
    
    return self->_popoverView;
}

- (UIView *)touchPointView
{
    if (!self->_touchPointView)
    {
        self->_touchPointView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, 3.0f, 3.0f)];
        self->_touchPointView.layer.borderWidth = 1.0f;
    }
    
    return self->_touchPointView;
}

#pragma mark - Actions
- (void)valueChangedForSegmentedControl:(UISegmentedControl *)segmentedControl
{
    self.popoverArrowDirection = pow(2, segmentedControl.selectedSegmentIndex);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    
    //
    if (self.popoverView.superview)
    {
        [self.popoverView dismissPopoverAnimated:YES];
        return;
    }
    else
    {
        [self.view addSubview:self.touchPointView];
        self.touchPointView.center = point;
    }
    
    
    self.popoverView.backgroundHelper.fillColor = [self randomColor].CGColor;
    [self.popoverView presentFromRect:self.touchPointView.frame
                               inView:self.view
              permittedArrowDirection:self.popoverArrowDirection 
                             animated:YES];
    
    //
    [self.view bringSubviewToFront:self.touchPointView];
}

- (UIColor *)randomColor
{
    static CGFloat saturation = 0.6, brightness = 0.7;
    
    //  debug
    NSInteger countOfItems = 200;
    NSInteger random = arc4random()%200;
    UIColor *color = [UIColor colorWithHue:(CGFloat)random/countOfItems
                                saturation:saturation
                                brightness:brightness
                                     alpha:.5f];
    return color;
}


@end
