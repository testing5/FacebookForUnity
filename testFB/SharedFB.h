//
//  SharedFB.h
//  testFB
//
//  Created by shawn on 8/2/12.
//  Copyright (c) 2012 shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBConnect.h"

@interface SharedFB : NSObject

+ (Facebook *)sharedFB;
+ (BOOL)isAlreadyLogin;

@end
