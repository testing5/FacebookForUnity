//
//  SharedFB.m
//  testFB
//
//  Created by shawn on 8/2/12.
//  Copyright (c) 2012 shawn. All rights reserved.
//

#import "SharedFB.h"


@implementation SharedFB


static Facebook *fb;
+ (Facebook *)sharedFB
{
    if (!fb) {
fb = [[Facebook alloc]initWithAppId:@"446512918705223" andDelegate:nil];
    }
    return fb;
}

+ (BOOL)isAlreadyLogin
{
    return [fb isSessionValid];
}

@end
