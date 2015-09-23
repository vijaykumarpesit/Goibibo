//
//  GoBusDetails.m
//  GoIbibo
//
//  Created by Vijay on 23/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoBusDetails.h"

@implementation GoBusDetails

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[self class]]) {
         GoBusDetails *busDetails = (GoBusDetails *)object;
        return [busDetails.rowID isEqualToString:self.rowID];
    }
    return NO;
}

- (NSUInteger)hash {
    NSUInteger result = 1;
    NSUInteger prime = 31;
    
    result = prime * result + [self.rowID hash];
    return result;
}
@end
