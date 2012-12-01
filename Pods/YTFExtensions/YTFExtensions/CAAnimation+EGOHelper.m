//
//  UIToolbarEGOHelper.h
//  Enormego Cocoa Helpers
//
//  Created by Devin Doty on 5/16/10.
//  Copyright 2010 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CAAnimation+EGOHelper.h"

@implementation CAAnimation (EGOHelper)

+ (CAKeyframeAnimation*)popInAnimation {
	CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
	
	animation.values = [NSArray arrayWithObjects:
									[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)],
									[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)],
									[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)],
							nil];
	
	animation.duration = 0.3f;
	return animation;
}

@end

@implementation UIView (CAAnimationEGOHelper)

- (void)popInAnimated {
	[self.layer popInAnimated];
}

@end

@implementation CALayer (CAAnimationEGOHelper)

- (void)popInAnimated {
	[self addAnimation:[CAAnimation popInAnimation] forKey:@"transform"];
}

@end
