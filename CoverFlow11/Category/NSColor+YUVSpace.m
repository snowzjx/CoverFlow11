//
//  NSColor+YUVSpace.m
//  CoverFlow11
//
//  Created by Snow on 12-12-29.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "NSColor+YUVSpace.h"

@implementation NSColor (YUVSpace)

+ (CGFloat)yComponentFromColor:(NSColor *)color
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0;
    CGFloat y = 0.0;
    if(color)
    {
        NSInteger numComponents = CGColorGetNumberOfComponents([color CGColor]);
        if(numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents([color CGColor]);
            red = components[0];
            green = components[1];
            blue = components[2];
            alpha = components[3];
        }
        y = 0.299*red + 0.587*green+ 0.114*blue;
    }
    return y;
}

+ (CGFloat)uComponentFromColor:(NSColor *)color
{
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0;
    CGFloat u = 0.0;
    if(color)
    {
        NSInteger numComponents = CGColorGetNumberOfComponents([color CGColor]);
        if(numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents([color CGColor]);
            red = components[0];
            green = components[1];
            blue = components[2];
            alpha = components[3];
        }
        u = (-0.14713)*red + (-0.28886)*green + (0.436)*blue;
    }
    return u;
}

+ (CGFloat)vComponentFromColor:(NSColor *)color
{
    
    CGFloat red = 0.0f;
    CGFloat green = 0.0f;
    CGFloat blue = 0.0f;
    CGFloat alpha = 0.0;
    CGFloat v = 0.0;
    if(color)
    {
        NSInteger numComponents = CGColorGetNumberOfComponents([color CGColor]);
        if(numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents([color CGColor]);
            red = components[0];
            green = components[1];
            blue = components[2];
            alpha = components[3];
        }
        v = 0.615*red + (-0.51499)*green + (-0.10001)*blue;
    }
    return v;
}

+ (CGFloat)YUVSpaceDistanceToColor:(NSColor *)toColor fromColor:(NSColor *)fromColor
{
    CGFloat distance = sqrtf([NSColor YUVSpaceSquareDistanceToColor:toColor fromColor:fromColor]);
    return distance;
}

+(CGFloat)YUVSpaceSquareDistanceToColor:(NSColor *)toColor fromColor:(NSColor *)fromColor
{
    CGFloat yToColor = [NSColor yComponentFromColor:toColor];
    CGFloat uToColor = [NSColor uComponentFromColor:toColor];
    CGFloat vToColor = [NSColor vComponentFromColor:toColor];
    
    CGFloat yFromColor = [NSColor yComponentFromColor:fromColor];
    CGFloat uFromColor = [NSColor uComponentFromColor:fromColor];
    CGFloat vFromColor = [NSColor vComponentFromColor:fromColor];
    
    CGFloat deltaY = yToColor - yFromColor;
    CGFloat deltaU = uToColor - uFromColor;
    CGFloat deltaV = vToColor - vFromColor;
    
    CGFloat distance = deltaY*deltaY + deltaU*deltaU + deltaV*deltaV;
    
    return distance;
}

@end
