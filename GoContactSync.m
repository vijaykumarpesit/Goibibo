//
//  GoContactSync.m
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoContactSync.h"
#import "GoContactSyncEntry.h"

@implementation GoContactSync


+ (instancetype)sharedInstance {
    
    static GoContactSync *contactSync = nil;
    
    if (!contactSync) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            contactSync = [[GoContactSync alloc] init];
        });
    }
    
    return contactSync;
}

+ (NSSet *)addressBookEntriesFromAddressBook:(CFTypeRef)addressBook {
    
    CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(addressBook);
    NSArray *pplArray = (NSArray *)CFBridgingRelease(people);
    NSInteger i, max;
    
    max = [pplArray count];
    NSMutableSet *addressBookEntries = [NSMutableSet setWithCapacity:max];
    
    for (i=0 ; i<max ; i++)
    {
        ABRecordRef person = CFBridgingRetain([pplArray objectAtIndex:i]);
        
        if (person)
        {
            ABMultiValueRef properties = ABRecordCopyValue(person, kABPersonPhoneProperty);
            NSArray *allProperties = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(properties);
            NSEnumerator *propertiesEneumerator = [allProperties objectEnumerator];
            NSString *phoneNumber;
            
            while (phoneNumber = [propertiesEneumerator nextObject])
            {
                ABRecordID recordId = ABRecordGetRecordID(person);
                
                NSString *firstName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
                NSString *lastName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
                NSString *middleName = (__bridge NSString *)ABRecordCopyValue(person, kABPersonMiddleNameProperty);
                
                NSString *fullName = nil;
                if (firstName)
                {
                    fullName = [NSString stringWithString:firstName];
                    if(middleName)
                        fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:middleName];
                    if (lastName)
                        fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:lastName];
                }
                else if(middleName)
                {
                    fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:middleName];
                    if (lastName)
                        fullName = [[fullName stringByAppendingString:@" "] stringByAppendingString:lastName];
                }
                else if (lastName)
                    fullName = [NSString stringWithString:lastName];
                
                if (phoneNumber.length > 0)
                    {
                        GoContactSyncEntry *entry = [[GoContactSyncEntry alloc] init];
                        entry.addressBookId = recordId;
                        entry.name = fullName;
                        entry.phoneNumber = phoneNumber;
                        [addressBookEntries addObject:entry];
                    }
                
                
                
                if (firstName)
                    CFRelease((__bridge CFTypeRef)(firstName));
                if (lastName)
                    CFRelease((__bridge CFTypeRef)(lastName));
                if (middleName)
                    CFRelease((__bridge CFTypeRef)(middleName));
            }
            if (allProperties)
                CFRelease((__bridge CFTypeRef)(allProperties));
            if (properties)
                CFRelease(properties);
        }
    }
    
    if (addressBook && addressBook!=NULL)
        CFRelease(addressBook);
    if (people)
        CFRelease(people);
    
    return addressBookEntries;
}

@end
