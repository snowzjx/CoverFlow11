//
//  Color11.m
//  CoverFlow11
//
//  Created by Snow on 12-12-30.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "Color11.h"
#import "NSColor+YUVSpace.h"
#import "NSImage+Color11.h"
#import "Color11Constant.h"

@interface Color11 ()

+ (NSImage *)_imageWithImage:(NSImage *)image scaledToSize:(NSSize)newSize;
+ (BOOL)_isSufficienteContrastBetweenBackground:(NSColor *)backgroundColor andForground:(NSColor *)foregroundColor;


@end

@implementation Color11
+ (NSDictionary*)dictionaryWithColorsPickedFromImage:(NSImage *)image
{
    NSColor *backgroundColor;
    NSColor *primaryTextColor;
    NSColor *secondaryTextColor;
        
    NSMutableDictionary *colorsDictionary = [[NSMutableDictionary alloc] init];
    
    NSImage *scaledImage = [self _imageWithImage:image scaledToSize:NSMakeSize(COLOR11_DEFAULT_SCALED_SIZE, COLOR11_DEFAULT_SCALED_SIZE)];
    
    NSArray *colorSchemeArray = [NSImage dominantsColorsFromImage:scaledImage threshold:COLOR11_DEFAULT_DOMINANTS_TRESHOLD numberOfColors:COLOR11_DEFAULT_NUM_OF_DOMINANTS];
    
    if([colorSchemeArray count] >= 1)
    {
        backgroundColor = [colorSchemeArray objectAtIndex:0];
        [colorsDictionary setObject:backgroundColor forKey:@"BackgroundColor"];
    }
    
    if([colorSchemeArray count] >= 2)
    {
        primaryTextColor = [colorSchemeArray objectAtIndex:1];
        if([self _isSufficienteContrastBetweenBackground:backgroundColor andForground:primaryTextColor])
        {
            [colorsDictionary setObject:primaryTextColor forKey:@"PrimaryTextColor"];
        }
        else
        {
            if([NSColor yComponentFromColor:backgroundColor] < 0.5)
            {
                [colorsDictionary setObject:[NSColor whiteColor] forKey:@"PrimaryTextColor"];
            }
            else
            {
                [colorsDictionary setObject:[NSColor blackColor] forKey:@"PrimaryTextColor"];
            }
        }
    }
    else
    {
        if([NSColor yComponentFromColor:backgroundColor] < 0.5)
        {
            [colorsDictionary setObject:[NSColor whiteColor] forKey:@"PrimaryTextColor"];
        }
        else
        {
            [colorsDictionary setObject:[NSColor blackColor] forKey:@"PrimaryTextColor"];
        }
    }
    
    if([colorSchemeArray count] >= 3)
    {
        secondaryTextColor = [colorSchemeArray objectAtIndex:2];
        if([self _isSufficienteContrastBetweenBackground:backgroundColor andForground:secondaryTextColor])
        {
            [colorsDictionary setObject:secondaryTextColor forKey:@"SecondaryTextColor"];
        }
        else
        {
            if([NSColor yComponentFromColor:backgroundColor] < 0.5)
            {
                [colorsDictionary setObject:[NSColor whiteColor] forKey:@"SecondaryTextColor"];
            }
            else
            {
                [colorsDictionary setObject:[NSColor blackColor] forKey:@"SecondaryTextColor"];
            }
        }
    }
    else
    {
        if([NSColor yComponentFromColor:backgroundColor] < 0.5)
        {
            [colorsDictionary setObject:[NSColor whiteColor] forKey:@"SecondaryTextColor"];
        }
        else
        {
            [colorsDictionary setObject:[NSColor blackColor] forKey:@"SecondaryTextColor"];
        }
    }
    return colorsDictionary;
}

+ (NSImage *)_imageWithImage:(NSImage *)image scaledToSize:(NSSize)newSize
{
    NSImage *newImage = [[NSImage alloc] initWithSize:newSize];
    NSRect toRect = NSMakeRect(0.0f, 0.0f, newSize.width, newSize.height);
    NSRect fromRect = NSMakeRect(0.0f, 0.0f, image.size.width, image.size.height);
    [newImage lockFocus];
    [image drawInRect:toRect fromRect:fromRect operation:NSCompositeCopy fraction:1.0f];
    [newImage unlockFocus];
    return newImage;
}

+ (BOOL)_isSufficienteContrastBetweenBackground:(NSColor *)backgroundColor andForground:(NSColor *)foregroundColor
{
    CGFloat backgroundColorBrightness = [NSColor yComponentFromColor:backgroundColor];
    CGFloat foregroundColorBrightness = [NSColor yComponentFromColor:foregroundColor];
    CGFloat brightnessDifference = ABS(backgroundColorBrightness - foregroundColorBrightness);
    
    if(brightnessDifference >= COLOR11_DEFAULT_BRIGHTNESS_DIFFERENCE)
    {
        CGFloat backgroundRed = 0.0f;
        CGFloat backgroundGreen = 0.0f;
        CGFloat backgroundBlue = 0.0f;
        CGFloat foregroundRed = 0.0f;
        CGFloat foregroundGreen = 0.0f;
        CGFloat foregroundBlue = 0.0f;
        
        NSInteger numComponents = CGColorGetNumberOfComponents([backgroundColor CGColor]);
        
        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents([backgroundColor CGColor]);
            backgroundRed = components[0];
            backgroundGreen = components[1];
            backgroundBlue = components[2];
        }
        
        numComponents = CGColorGetNumberOfComponents([foregroundColor CGColor]);
        
        if (numComponents == 4) {
            const CGFloat *components = CGColorGetComponents([foregroundColor CGColor]);
            foregroundRed = components[0];
            foregroundGreen = components[1];
            foregroundBlue = components[2];
        }
        
        CGFloat colorDifference =
        (MAX(backgroundRed,foregroundRed)-MIN(backgroundRed, foregroundRed)) +
        (MAX(backgroundGreen,foregroundGreen)-MIN(backgroundGreen, foregroundGreen)) +
        (MAX(backgroundBlue,foregroundBlue)-MIN(backgroundBlue, foregroundBlue));
        if(colorDifference > COLOR11_DEFAULT_COLOR_DIFFERENCE)
        {
            return YES;
        }
    }
    return NO;
}

@end
