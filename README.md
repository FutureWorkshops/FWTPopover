#FWTProgressView

![FWTProgressView screenshot](http://grab.by/g0rw)


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

**animationType** transition type that can be used (animation direction)

**animationDuration** amount of time it takes to move from 0 to progressImage width.

**contentHorizontalInset** the value to use to adjust the width of the content view. To create an inset rectangle, specify a positive value. To create a larger, encompassing rectangle, specify a negative value.

**contentCornerRadius** specifies a radius used to draw the rounded corners of the content view. The default value is 0.0.

**borderEdgeInsets** the inset or outset margins for the edges of the border view. Use this property to resize and reposition the effective rectangle.


##View hierarchy
For a better understanding it can be useful to see the subviews/sublayers involved. Between braces the available public properties.

- **progressView** {progress, animationType, animationDuration}
	- **contentView** {contentHorizontalInset, contentCornerRadius} 
		- **progressLayer**
		- **trackView**
	- **borderView** {borderEdgeInsets}

##For your interest
The class method **defaultProgressView** creates for you the following images:

* progressImage		![FWTProgressView progressImage](http://grab.by/g9Lq)
* trackImage		![FWTProgressView trackImage](http://grab.by/g9Ly)
* borderImage		![FWTProgressView borderImage](http://grab.by/g9LA) 

##Demo
The sample project shows how to use and how to create a custom FWTProgressView.
If you don't have time to read it this is what you need:

    // i'm happy with the default
    self.progressView = [FWTProgressView defaultProgressView];
    [self.view addSubview:self.progressView];
    
	// set the frame width
    CGRect frame = CGRectInset(self.view.bounds, 10.0f, .0f);
    frame.size.height = self.progressView.frame.size.height;
    self.progressView.frame = frame;


##Licensing
Apache License Version 2.0

##Support, bugs and feature requests
If you want to submit a feature request, please do so via the issue tracker on github.
If you want to submit a bug report, please also do so via the issue tracker, including a diagnosis of the problem and a suggested fix (in code).
