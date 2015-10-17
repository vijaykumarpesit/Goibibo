//
//  GoHotelViewController.h
//  GoIbibo
//
//  Created by Vijay on 17/10/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoHotelViewController : UIViewController
@property (weak, nonatomic) IBOutlet UICollectionView *hotelCollectionView;
@property (nonatomic, strong) NSString *cityID;
@property (nonatomic, strong) NSDate *checkInDate;
@property (nonatomic, strong) NSDate *checkoutDate;
@end
