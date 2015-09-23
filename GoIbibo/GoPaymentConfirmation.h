//
//  GoPaymentConfirmation.h
//  GoIbibo
//
//  Created by Vijay on 24/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoPaymentConfirmation : UIViewController

- (instancetype)initWithSkey:(NSString *)skey
                      seatNo:(NSString *)seatNo
               departureDate:(NSDate *)departureDate;
@end
