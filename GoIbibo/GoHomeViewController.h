//
//  ViewController.h
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DigitsKit/DigitsKit.h>
#import <JTCalendar/JTCalendar.h>

typedef void (^HomeCompletionBlock)(NSString *destination, NSString *source, NSDate *date);


@interface GoHomeViewController : UIViewController<DGTCompletionViewController, JTCalendarDelegate>


@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *calendarContentView;

@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet UILabel *searchBusesLabel;
@property (weak, nonatomic) IBOutlet UILabel *assitance;
@property (nonatomic, copy) NSString *searchBusText;
@property (nonatomic, copy) HomeCompletionBlock homeCompletionBlock;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *calendarContentViewHeight;

@end


