//
//  GoHotel.h
//  GoIbibo
//
//  Created by Vijay on 17/10/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoHotel : NSObject

@property (nonatomic, strong) NSString *hotelID;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSNumber *lattitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *price;
@property (nonatomic, strong) NSString *selectedFriendName;
@property (nonatomic, strong) NSString *selctedFriendNumber;
@property (nonatomic, strong) NSNumber *noOfRoomsAvailable;
@end
