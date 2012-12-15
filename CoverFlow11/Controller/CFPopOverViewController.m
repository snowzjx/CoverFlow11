//
//  CFPopOverViewController.m
//  CoverFlow11
//
//  Created by Snow on 12-12-11.
//  Copyright (c) 2012年 Snow. All rights reserved.
//

#import "CFPopOverViewController.h"
#import "iTunesAccess.h"
#import "CFView.h"

@interface CFPopOverViewController ()

@end

@implementation CFPopOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSLog(@"CFPopOverViewController - Initializing CFPopOverViewController ...");
        theiTunesAccess = [iTunesAccess sharediTunesAccess];
    }
    return self;
}

- (void)didPopOver
{
    NSLog(@"CFPopOverViewController - Will Pop Over ...");
    if(![theiTunesAccess isiTunesRunning])
    {
        NSLog(@"CFPopOverViewController - Run iTunes ...");
        [theiTunesAccess runiTunes];
    }
    [cfView setUpLayers];
}

@end
