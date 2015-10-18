//
//  GoNotifyMeViewController.m
//  GoIbibo
//
//  Created by Sachin Vas on 10/18/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoNotifyMeViewController.h"
#import "GoBusInfoCell.h"
#import "GoSettingsOption.h"
#import "GoLayoutHandler.h"
#import "GoHomeViewController.h"
#import <parse/parse.h>
#import "GoUserModelManager.h"

@interface GoNotifyMeViewController ()

@property (nonatomic, strong) NSMutableArray *subscriptions;

@end

@implementation GoNotifyMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Notify Me";
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoBusInfoCell" bundle:nil] forCellReuseIdentifier:@"NotifyMeSubscriptionCellIdentifier"];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-side-bar-hamburger.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];

    self.subscriptions = [NSMutableArray array];
    [self configureDataSource];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)configureDataSource {
    [self.subscriptions removeAllObjects];
    
    [self retireveFromUserDefaultsForIndex:0];
    if (self.subscriptions.count != 1) {
        GoSettingsOption *settingsOption = [[GoSettingsOption alloc] init];
        settingsOption.optiontext = @"Courier Services";
        settingsOption.showDisclosureIndicator = YES;
        [self.subscriptions addObject:settingsOption];
    }
    
    [self retireveFromUserDefaultsForIndex:1];
    if (self.subscriptions.count != 2) {
        GoSettingsOption *profileOption = [[GoSettingsOption alloc] init];
        profileOption.optiontext = @"Long Weekend Plan";
        profileOption.showDisclosureIndicator = YES;
        [self.subscriptions addObject:profileOption];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subscriptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoBusInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotifyMeSubscriptionCellIdentifier" forIndexPath:indexPath];
    GoSettingsOption *settingOption = [self.subscriptions objectAtIndex:indexPath.row];
    cell.travellerName.text = settingOption.optiontext;
    if (settingOption.showDisclosureIndicator) {
        cell.minimumFare.text = @"     Opt For     ";
        cell.minimumFare.layer.borderColor = [UIColor colorWithRed:(75.0f/255.0f) green:(174.0f/255.0f) blue:(39.0f/255.0f) alpha:1.0f].CGColor;
        cell.minimumFare.layer.borderWidth = 1.0;
        cell.minimumFare.layer.cornerRadius = 1.0f;
    } else {
        cell.minimumFare.text = @"You are already Subscribed";
    }
    cell.busTypeName.text = nil;
    cell.availableSeats.text = nil;
    cell.departureToArrivalTime.text = nil;
    // Configure the cell...
    
    return cell;
}

- (void)retireveFromUserDefaultsForIndex:(NSInteger)index {
    NSDictionary *standardUserDefaults = [[NSUserDefaults standardUserDefaults] valueForKey:@"Subscription"];
    if (standardUserDefaults) {
        GoSettingsOption *subscription = [NSKeyedUnarchiver unarchiveObjectWithData:[standardUserDefaults valueForKey:[NSString stringWithFormat:@"%ld", (long)index]]];
        ;
        if (subscription) {
            [self.subscriptions addObject:subscription];
        }
    }
}

- (void)saveToUserDefaultsForIndex:(NSInteger)index {
    GoSettingsOption *option = [self.subscriptions objectAtIndex:index];
    option.showDisclosureIndicator = NO;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.subscriptions[index]];
    NSDictionary *dict = @{[NSString stringWithFormat:@"%ld", (long)index]:data};
    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"Subscription"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)leftBarButtonItemPressed:(id)sender {
    [[[GoLayoutHandler sharedInstance] sideMenu] presentLeftMenuViewController];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GoHomeViewController *homeVC = [[GoHomeViewController alloc] initWithNibName:@"GoHomeViewController" bundle:nil];
    homeVC.searchBusText = [self.subscriptions[indexPath.row] optiontext];
    homeVC.homeCompletionBlock = ^void(NSString *destination, NSString *source, NSDate *date) {
        PFObject *subscribeService = [PFObject objectWithClassName:@"SubscribeService"];
        subscribeService[@"phoneNumber"] = [[[GoUserModelManager sharedManager] currentUser] phoneNumber];
        if ([[PFInstallation currentInstallation] deviceToken]) {
            subscribeService[@"deviceToken"] = [[PFInstallation currentInstallation] deviceToken];
        }
        subscribeService[@"source"] = source;
        subscribeService[@"destination"] = destination;
        subscribeService[@"departureDate"] = date;
        
        [subscribeService saveInBackground];
    };
    [self saveToUserDefaultsForIndex:indexPath.row];
    [self.navigationController pushViewController:homeVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
