//
//  NSImage+Color11.m
//  CoverFlow11
//
//  Created by Snow on 12-12-29.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "NSImage+Color11.h"
#import "NSColor+YUVSpace.h"

@implementation NSImage (Color11)

+ (NSArray *)dominantsColorsFromImage:(NSImage *)image threshold:(CGFloat)threshold numberOfColors:(NSUInteger)numberOfColors
{
    NSArray *pixelArray;
    NSArray *buckets;
    NSArray *sortedBuckets;
    NSColor *dominantColor;
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    CGFloat count = image.size.width * image.size.height;
    
    for(NSUInteger i = 0; i < numberOfColors; i++)
    {
        @autoreleasepool
        {
            if(i==0)
            {
                pixelArray = [NSImage getRGBAsFromImage:image atX:0 andY:0 count:(NSUInteger)count];
            }
            else
            {
                pixelArray = [self _filterColor:dominantColor fromPixelArray:pixelArray threshold:0.3f];
            }
            
            buckets = [self _gather:pixelArray forThreshold:threshold];
            
            sortedBuckets = [self _sortedBucketsFromArray:buckets forKey:@"@count" ascending:NO];
            
            if([sortedBuckets count])
            {
                dominantColor = [[sortedBuckets objectAtIndex:0] objectAtIndex:0];
                [returnArray addObject:dominantColor];
            }
        }
    }
    return returnArray;
}

+ (NSArray *)getRGBAsFromImage:(NSImage *)image atX:(NSInteger)xx andY:(NSInteger)yy count:(NSInteger)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    CGImageRef imageRef = [image CGImageForProposedRect:NULL context:NULL hints:NULL];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    NSInteger byteIndex = (bytesPerRow * yy) + xx * bytesPerPixel;
    for (int ii = 0 ; ii < count ; ++ii)
    {
        @autoreleasepool {
            CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
            CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
            CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
            CGFloat alpha = (rawData[byteIndex + 3] * 1.0) / 255.0;
            byteIndex += 4;
            
            NSColor *aColor= [NSColor colorWithSRGBRed:red green:green blue:blue alpha:alpha];
            [result addObject:aColor];
        }
    }
    
    free(rawData);
    
    return result;
}


+ (NSArray *)_gather:(NSArray*)pixelArray forThreshold:(CGFloat)threshold
{
    NSUInteger i = 0;
    NSUInteger j = 0;
    NSMutableArray *finalArray = [[NSMutableArray alloc] init];
    NSMutableArray *auxPixelArray = [[NSMutableArray alloc] initWithArray:pixelArray];
    if ([pixelArray count]) {
        for (i=0; i<[pixelArray count]; i++) {
            NSColor *aColor = [pixelArray objectAtIndex:i];
            NSMutableArray *aArray = [[NSMutableArray alloc] init];
            for (j=0; j<[auxPixelArray count]; j++) {
                @autoreleasepool {
                    NSColor *otherColor = [auxPixelArray objectAtIndex:j];
                    CGFloat distance = [NSColor YUVSpaceSquareDistanceToColor:aColor fromColor:otherColor];
                    if (distance < (threshold * threshold)) {
                        [aArray addObject:otherColor];
                    }
                }
            }
            [auxPixelArray removeObjectsInArray:aArray];
            [finalArray addObject:aArray];
        }
    }
    return finalArray;
}

+ (NSArray *)_sortedBucketsFromArray:(NSArray*)array forKey:(NSString*)key ascending:(BOOL)ascending
{
    NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:key
                                                         ascending:ascending];
    NSArray *sds = [NSArray arrayWithObject:sd];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sds];
    
    return sortedArray;
}

+ (NSArray *)_filterColor:(NSColor *)color fromPixelArray:(NSArray*)pixelArray threshold:(CGFloat)threshold
{
    NSUInteger i = 0;
    NSMutableArray *filteredArray = [[NSMutableArray alloc] init];
    if ([pixelArray count]) {
        for (i = 0; i < [pixelArray count]; i++) {
            @autoreleasepool {
                NSColor *aColor = [pixelArray objectAtIndex:i];
                CGFloat distance = [NSColor YUVSpaceSquareDistanceToColor:aColor fromColor:color];
                if (distance > (threshold * threshold)) {
                    [filteredArray addObject:aColor];
                }
            }
        }
    }
    return (NSArray *)filteredArray;
}


@end
