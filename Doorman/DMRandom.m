//
//  JWRandom.m
//  John Wayne
//
//  Created by Gabriel Reimers on 10.03.09.
//  Copyright 2009 Apple. All rights reserved.
//

#import "DMRandom.h"

#define ARC4RANDOM_MAX      0x100000000


@implementation DMRandom

- (DMRandom*) init {
	self = [super init];  
    if (self) {
        /*
         NSLog(@"testing random");
         for (int i = 0; i < 20; i++) {
         NSInteger r = [self randomIntBetween:5 and:20];
         NSLog(@"test random %ld", (long)r);
         }
         for (int i = 0; i < 20; i++) {
         CGFloat r = [self randomFloatBetween:5 and:20];
         NSLog(@"test random %f", r);
         }			
         */
	}
	return self;
}



//random between a and b including a and b
- (NSInteger) randomIntBetween: (NSInteger) a and: (NSInteger) b {
    NSInteger range = b - a + 1; 
    NSInteger zeroValue = arc4random() % range;
    NSInteger value = zeroValue + a;
    return value;
}

//random between a and b including a and b
- (CGFloat) randomFloatBetween: (CGFloat) a and: (CGFloat) b {
    CGFloat zeroValue = (CGFloat)arc4random() / (CGFloat)ARC4RANDOM_MAX;
    CGFloat range = b - a; 
    return (a + zeroValue * range);
}



@end
