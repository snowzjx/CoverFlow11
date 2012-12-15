//
//  CFView.m
//  CoverFlow11
//
//  Created by Snow on 12-12-14.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFView.h"

@implementation CFView

- (void)awakeFromNib
{
    NSLog(@"CFView - Awake From Nib ...");
    NSLog(@"CFView - Set Up the Root Layer ...");
    rootLayer = [CALayer layer];
    CGColorRef blackColor = CGColorCreateGenericRGB(0.0f, 0.0f, 0.0f, 1.0f);
    [rootLayer setBackgroundColor:blackColor];
    [rootLayer setCornerRadius:5.0f];
    
    [self setLayer:rootLayer];
    [self setWantsLayer:YES];
    NSLog(@"CFView - Finish Setting Up Root Layer ...");
}

- (void)setUpLayers
{
    NSLog(@"CFView - Setting Up Layers ...");
    
    
}

@end
