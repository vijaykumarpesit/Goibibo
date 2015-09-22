//
//  GoContactSync.h
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoContactSync : NSObject
+ (instancetype)sharedInstance;
+ (NSSet *)addressBookEntriesFromAddressBook:(CFTypeRef)addressBook;

@end
