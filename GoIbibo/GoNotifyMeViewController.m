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

@interface GoNotifyMeViewController ()

@property (nonatomic, strong) NSMutableArray *subscriptions;

@end

@implementation GoNotifyMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoBusInfoCell" bundle:nil] forCellReuseIdentifier:@"NotifyMeSubscriptionCellIdentifier"];
    
    [self configureDataSource];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)configureDataSource {
    [self.subscriptions removeAllObjects];
    
    [self retireveFromUserDefaultsForIndex:0];
    if (![self.subscriptions objectAtIndex:0]) {
        GoSettingsOption *settingsOption = [[GoSettingsOption alloc] init];
        settingsOption.optiontext = @"Destination";
        settingsOption.showDisclosureIndicator = NO;
        [self.subscriptions addObject:settingsOption];
    }
    
    [self retireveFromUserDefaultsForIndex:1];
    if (![self.subscriptions objectAtIndex:1]) {
        GoSettingsOption *profileOption = [[GoSettingsOption alloc] init];
        profileOption.optiontext = @"People";
        profileOption.showDisclosureIndicator = NO;
        [self.subscriptions addObject:profileOption];
    }
    
    [self retireveFromUserDefaultsForIndex:2];
    if (![self.subscriptions objectAtIndex:2]) {
        GoSettingsOption *logoutOption = [[GoSettingsOption alloc] init];
        logoutOption.optiontext = @"Date";
        logoutOption.showDisclosureIndicator = NO;
        [self.subscriptions addObject:logoutOption];
    }
    
    [self retireveFromUserDefaultsForIndex:3];
    if (![self.subscriptions objectAtIndex:3]) {
        GoSettingsOption *logoutOption1 = [[GoSettingsOption alloc] init];
        logoutOption1.optiontext = @"Age";
        logoutOption1.showDisclosureIndicator = NO;
        [self.subscriptions addObject:logoutOption1];
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
    
    // Configure the cell...
    
    return cell;
}

- (void)retireveFromUserDefaultsForIndex:(NSInteger)index {
    NSDictionary *standardUserDefaults = [[NSUserDefaults standardUserDefaults] valueForKey:@"Subscription"];
    if (standardUserDefaults) {
        NSArray *subscription = [standardUserDefaults valueForKey:[NSString stringWithFormat:@"%ld", (long)index]];
        if (subscription) {
            [self.subscriptions addObject:subscription];
        }
    }
}

- (void)saveToUserDefaultsForIndex:(NSInteger)index {
    [[NSUserDefaults standardUserDefaults] setValue:@{self.subscriptions[index]: [NSString stringWithFormat:@"%ld", (long)index]} forKey:@"Subscription"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
