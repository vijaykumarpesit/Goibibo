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
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *lattitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *price;
@end
