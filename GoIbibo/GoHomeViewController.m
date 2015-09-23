//
//  ViewController.m
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoHomeViewController.h"
#import "GoLayoutHandler.h"
#import "GoBusListViewController.h"
#import "GoUserModelManager.h"
#import "GoUser.h"

@interface GoHomeViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *eventsByDate;
@property (nonatomic, strong) NSDate *todayDate;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *dateSelected;
@property (weak, nonatomic) IBOutlet UIPickerView *sourcePickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *destinationPickerView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSMutableArray *sourcePlaces;
@property (nonatomic, strong) NSMutableArray *destinationPlaces;
@property (nonatomic) NSUInteger selectedSource;
@property (nonatomic) NSUInteger selectedDestination;

@end

@implementation GoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search Buses";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-side-bar-hamburger.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    _calendarManager = [JTCalendarManager new];
    _calendarManager.delegate = self;
    
    // Generate random events sort by date using a dateformatter for the demonstration
    [self createRandomEvents];
    
    // Create a min and max date for limit the calendar, optional
    [self createMinAndMaxDate];
    
    [_calendarManager setMenuView:_calendarMenuView];
    [_calendarManager setContentView:_calendarContentView];
    [_calendarManager setDate:_todayDate];

    [self didChangeModeTouch];
    _sourcePickerView.showsSelectionIndicator = YES;
    _destinationPickerView.showsSelectionIndicator = YES;
    [self configureSourceAndDestination];
    self.sourcePickerView.layer.cornerRadius = 8.0f;
    self.destinationPickerView.layer.cornerRadius = 8.0f;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.sourcePickerView selectRow:1 inComponent:0 animated:YES];
    self.selectedSource = 1;
    [self.destinationPickerView selectRow:1 inComponent:0 animated:YES];
    self.selectedDestination = 1;
}

- (void)configureSourceAndDestination {
    _sourcePlaces = [NSMutableArray array];
    [_sourcePlaces addObject:@"Bangalore"];
    [_sourcePlaces addObject:@"Chennai"];
    [_sourcePlaces addObject:@"Sirsi"];
    [_sourcePlaces addObject:@"Kollam"];
    [_sourcePlaces addObject:@"Hyderabad"];
    
    _destinationPlaces = [NSMutableArray array];
    [_destinationPlaces addObject:@"Hyderabad"];
    [_destinationPlaces addObject:@"Kollam"];
    [_destinationPlaces addObject:@"Sirsi"];
    [_destinationPlaces addObject:@"Chennai"];
    [_destinationPlaces addObject:@"Bangalore"];
}

#pragma mark - Buttons callback

- (IBAction)didGoTodayTouch
{
    [_calendarManager setDate:_todayDate];
}

- (IBAction)didChangeModeTouch
{
    _calendarManager.settings.weekModeEnabled = !_calendarManager.settings.weekModeEnabled;
    [_calendarManager reload];
    
    CGFloat newHeight = 300;
    [self.view bringSubviewToFront:self.overlayView];
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.90f alpha:0.73f];
    if(_calendarManager.settings.weekModeEnabled){
        newHeight = 85.;
        self.overlayView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        [self.view sendSubviewToBack:self.overlayView];
    }
    [UIView animateWithDuration:0.2f animations:^{
        self.calendarContentViewHeight.constant = newHeight;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)submitButtonClicked:(id)sender {
    NSString *source = [self.sourcePlaces[self.selectedSource] lowercaseString];
    NSString *destination = [self.destinationPlaces[self.selectedDestination] lowercaseString];
    if ([source isEqualToString:destination]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Same Destination" message:[NSString stringWithFormat:@"Please set the proper source/destination"] preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self.navigationController presentViewController:alertController animated:YES completion:nil];
    } else {
        GoBusListViewController *vc = [[GoBusListViewController alloc] initWithSource:source destination:destination departureDate:(_dateSelected ? _dateSelected : _todayDate) arrivalDate:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_calendarManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor whiteColor];
        dayView.dotView.backgroundColor = [UIColor colorWithWhite:0.4f alpha:0.3f];
        dayView.textLabel.textColor = [UIColor colorWithRed:1.0f green:(130.0f/255.0f) blue:(125.0f/255.0f) alpha:1.0f];
    }
    // Selected date
    else if(_dateSelected && [_calendarManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.4f];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    if([self haveEventForDay:dayView.date]){
        dayView.dotView.hidden = NO;
    }
    else{
        dayView.dotView.hidden = YES;
    }
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_calendarManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_calendarManager.dateHelper date:_calendarContentView.date isTheSameMonthThan:dayView.date]){
        if([_calendarContentView.date compare:dayView.date] == NSOrderedAscending){
            [_calendarContentView loadNextPageWithAnimation];
        }
        else{
            [_calendarContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
{
    return [_calendarManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Next page loaded");
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    //    NSLog(@"Previous page loaded");
}

#pragma mark - Fake data

- (void)createMinAndMaxDate
{
    _todayDate = [NSDate date];
    
    // Min date will be 2 month before today
    _minDate = [_calendarManager.dateHelper addToDate:_todayDate months:-2];
    
    // Max date will be 2 month after today
    _maxDate = [_calendarManager.dateHelper addToDate:_todayDate months:2];
}

// Used only to have a key for _eventsByDate
- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

- (BOOL)haveEventForDay:(NSDate *)date
{
    NSString *key = [[self dateFormatter] stringFromDate:date];
    
    if(_eventsByDate[key] && [_eventsByDate[key] count] > 0){
        return YES;
    }
    
    return NO;
    
}

- (void)createRandomEvents
{
    _eventsByDate = [NSMutableDictionary new];
    
    for(int i = 0; i < 30; ++i){
        // Generate 30 random dates between now and 60 days later
        NSDate *randomDate = [NSDate dateWithTimeInterval:(rand() % (3600 * 24 * 60)) sinceDate:[NSDate date]];
        
        // Use the date as key for eventsByDate
        NSString *key = [[self dateFormatter] stringFromDate:randomDate];
        
        if(!_eventsByDate[key]){
            _eventsByDate[key] = [NSMutableArray new];
        }
        
        [_eventsByDate[key] addObject:randomDate];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonItemPressed:(id)sender {
    [[[GoLayoutHandler sharedInstance] sideMenu] presentLeftMenuViewController];
}

-(void)digitsAuthenticationFinishedWithSession:(DGTSession *)aSession error:(NSError *)error {
    
    GoUser *user = [[GoUserModelManager sharedManager] currentUser];
    user.phoneNumber = aSession.phoneNumber;
    user.userID = aSession.userID;
    [user saveUser];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if ([pickerView isEqual:self.sourcePickerView]) {
         self.selectedSource = row;
    } else {
        self.selectedDestination = row;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if ([pickerView isEqual:self.sourcePickerView]) {
        return self.sourcePlaces.count;
    } else {
        return self.destinationPlaces.count;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0f];
        label.textColor = [UIColor colorWithRed:(80.0f/255.0f) green:(80.0f/255.0f) blue:(80.0f/255.0f) alpha:1.0f];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [pickerView isEqual:self.sourcePickerView] ? self.sourcePlaces[row] : self.destinationPlaces[row];
    return label;
}

@end
