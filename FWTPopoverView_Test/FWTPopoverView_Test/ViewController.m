//
//  ViewController.m
//  FWTPopoverHintView_Test
//
//  Created by Marco Meschini on 8/6/12.
//  Copyright (c) 2012 Futureworkshops. All rights reserved.
//

#import "ViewController.h"
#import "FWTPopoverView.h"

CGFloat(^FWTRandomFloat)(CGFloat, CGFloat) = ^(CGFloat lowerBound, CGFloat upperBound){
    CGFloat diff = upperBound - lowerBound;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + lowerBound;
};

@interface ViewController ()
@property (nonatomic, retain) FWTPopoverView *popoverView;
@property (nonatomic, retain) UIView *touchPointView;
@property (nonatomic, assign) FWTPopoverArrowDirection popoverArrowDirection;
@end

@implementation ViewController

- (void)dealloc
{
    self.touchPointView = nil;
    self.popoverView = nil;
    [super dealloc];
}

- (id)init
{
    if ((self = [super init]))
    {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                                target:self
                                                                                                action:@selector(_didPressRightBarButton:)] autorelease];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView.scrollEnabled = NO;
    
    UITapGestureRecognizer *gesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleGesture:)] autorelease];
    [self.view addGestureRecognizer:gesture];
    
    self.popoverArrowDirection = pow(2, 0); //  store the selected arrow type
    
    //  allow to change arrow type
    UISegmentedControl *segmentedControl = [[[UISegmentedControl alloc] initWithItems:@[@"N", @"U", @"D", @"L", @"R"]] autorelease];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(_valueChangedForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex = log2(self.popoverArrowDirection);
    [segmentedControl sizeToFit];
    self.navigationItem.titleView = segmentedControl;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.popoverView removeFromSuperview];
    self.popoverView = nil;
    
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - Getters
- (UIView *)touchPointView
{
    if (!self->_touchPointView)
    {
        self->_touchPointView = [[UIView alloc] initWithFrame:CGRectMake(.0f, .0f, 4.0f, 4.0f)];
        self->_touchPointView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:.5f];
        self->_touchPointView.layer.borderWidth = 1.0f;
        self->_touchPointView.layer.cornerRadius = 2.0f;
    }
    
    return self->_touchPointView;
}

#pragma mark - Actions
- (void)_valueChangedForSegmentedControl:(UISegmentedControl *)segmentedControl
{
    self.popoverArrowDirection = pow(2, segmentedControl.selectedSegmentIndex);
}

- (void)_didPressRightBarButton:(UIBarButtonItem *)barButton
{
    NSArray *arrayCopy = [NSArray arrayWithArray:self.view.subviews];
    [arrayCopy enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[FWTPopoverView class]])
            [(FWTPopoverView *)subview dismissPopoverAnimated:YES];
    }];
}

#pragma mark - UIResponder
- (void)_handleGesture:(UIGestureRecognizer *)gesture
{    
    CGPoint point = [gesture locationInView:gesture.view];
    
    //
    if (!self.popoverView || self.manyPopoversEnabled)
    {
        self.popoverView = [[[FWTPopoverView alloc] init] autorelease];
        self.popoverView.contentSize = CGSizeMake(self.popoverView.contentSize.width, ((int)FWTRandomFloat(60, 100))); // random height
        __block typeof(self) myself = self;
        self.popoverView.didDismissBlock = ^(FWTPopoverView *av){ myself.popoverView = nil; }; // release
        CGColorRef fillColor = self.manyPopoversEnabled ? [self _pleaseGiveMeARandomColor].CGColor : self.popoverView.backgroundHelper.fillColor;
        self.popoverView.backgroundHelper.fillColor = fillColor; // random color if many popover at the same time is enabled
        [self.popoverView presentFromRect:CGRectMake(point.x, point.y, 1.0f, 1.0f)
                                   inView:self.view
                  permittedArrowDirection:self.popoverArrowDirection
                                 animated:YES];
    }
    else if (!self.manyPopoversEnabled)
        [self.popoverView dismissPopoverAnimated:YES];
    
    
    //  show the touch (useful to see how the adjustPositionInSuperviewEnabled works)
    //
    if (!self.touchPointView.superview) [self.view addSubview:self.touchPointView];
    self.touchPointView.center = point;
    [self.view bringSubviewToFront:self.touchPointView];
}

#pragma mark - Private
- (UIColor *)_pleaseGiveMeARandomColor
{
    NSInteger countOfItems = 200;
    NSInteger random = arc4random()%countOfItems;
    UIColor *color = [UIColor colorWithHue:(CGFloat)random/countOfItems saturation:.6f brightness:.7f alpha:.5f];
    return color;
}


@end
