//
//  GoSettingsOption.m
//  GoIbibo
//
//  Created by Sachin Vas on 9/22/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSettingsOption.h"

@implementation GoSettingsOption

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.imageName forKey:@"imageName"];
    [coder encodeObject:self.optiontext forKey:@"optionText"];
    [coder encodeObject:@(self.showDisclosureIndicator) forKey:@"showDisclosureIndicator"];
    [coder encodeObject:@(self.indentationLevel) forKey:@"indentationLevel"];
    [coder encodeObject:@(self.expanded) forKey:@"expanded"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.imageName = [coder decodeObjectForKey:@"imageName"];
        self.optiontext = [coder decodeObjectForKey:@"optionText"];
        self.showDisclosureIndicator = [[coder decodeObjectForKey:@"showDisclosureIndicator"] boolValue];
        self.indentationLevel = [[coder decodeObjectForKey:@"indentationLevel"] integerValue];
        self.expanded = [[coder decodeObjectForKey:@"expanded"] boolValue];
    }
    return self;
}

@end
