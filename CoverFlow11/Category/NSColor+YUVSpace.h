//
//  NSColor+YUVSpace.h
//  CoverFlow11
//
//  Created by Snow on 12-12-29.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (YUVSpace)

+ (CGFloat)yComponentFromColor:(NSColor *)color;
+ (CGFloat)uComponentFromColor:(NSColor*)color;
+ (CGFloat)vComponentFromColor:(NSColor*)color;
+ (CGFloat)YUVSpaceDistanceToColor:(NSColor *)toColor fromColor:(NSColor *)fromColor;
+ (CGFloat)YUVSpaceSquareDistanceToColor:(NSColor *)toColor fromColor:(NSColor *)fromColor;
@end
