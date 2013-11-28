//
//  JWRandom.h
//  John Wayne
//
//  Created by Gabriel Reimers on 10.03.09.
//  Copyright 2009 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface DMRandom : NSObject {
    
    
}

- (NSInteger) randomIntBetween: (NSInteger) a and: (NSInteger) b;
- (CGFloat) randomFloatBetween: (CGFloat) a and: (CGFloat) b;
- (DMRandom*) init;
@end
