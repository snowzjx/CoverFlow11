//
//  CFView.h
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CFView : NSView
{
    // Layers
    CALayer *_rootLayer;
    CALayer *_coverFlowLayer;
    CAScrollLayer *_scrollLayer;
    
    // CATransform3D
    CATransform3D _leftTransform;
    CATransform3D _rightTransform;
    CATransform3D _subLayerTransform;
    CATransform3D _reflectionTransform;
}

extern NSString * const selectedCoverDoubleClickedNotification;
extern NSString * const selectedCoverClickedNotification;

@property(nonatomic, copy) NSArray* content;

@property(nonatomic, assign) NSInteger selectedIndex;

@end
