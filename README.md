#FWTPopoverView

![FWTPopoverView screenshot](http://grab.by/hc1q)


FWTProgressView shows the progress of a task over time. The progress image, by default, is animated from left to right. As with UIProgressView you can set the progress value with or without animation.

##Requirements
* XCode 4.4.1 or higher
* iOS 5.0

##Features
The FTWProgressView uses the method resizableImageWithCapInsets introduced in IOS 5.0 so, it won't work on any prior version. The idea behind is: provide your own custom images to the FWTProgressView and it will do the rest for you. FTWProgressView creates a patterned background color from *progressImage* and animates the layer position. The default progressView doesn't use any external asset.

This project is not yet ARC-ready.

##How to use it: initializing

FWTProgressView can be initialized in the following ways:

* **defaultProgressView**
* **initWithProgressImage:trackImage:borderImage:**

**Parameters**

*progressImage* a tile image used as pattern and eventually animated 

*trackImage* a stretchable image

*borderImage* a stretchable image

**Discussion**

FWTProgressView uses its default values if any of the passed params is nil.


##How to use it: configure

####FWTPopoverBackgroundHelper 

####FWTPopoverAnimationHelper

####FWTPopoverArrow 



##View hierarchy
For a better understanding it can be useful to see the subviews/sublayers involved. Between braces the available public properties.

- **popoverView** {contentSize, adjustPositionInSuperviewEnabled}
    - **backgroundImageView**
	- **contentView** 

##For your interest


##Demo
The sample project shows how to use and how to create a custom FWTProgressView.
If you don't have time to read it this is what you need:

	//	present
	FWTPopoverView *popoverView = [[[FWTPopoverView alloc] init] autorelease];
    [popoverView presentFromRect:rect
                          inView:self.view
         permittedArrowDirection:FWTPopoverArrowDirectionUp
                        animated:YES];
                        
    […]
    
    //	dismiss
    [popoverView dismissPopoverAnimated:YES];


##Licensing
Apache License Version 2.0

##Support, bugs and feature requests
If you want to submit a feature request, please do so via the issue tracker on github.
If you want to submit a bug report, please also do so via the issue tracker, including a diagnosis of the problem and a suggested fix (in code).
