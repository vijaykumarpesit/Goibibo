//
//  GoSettingsViewController.m
//  GoIbibo
//
//  Created by Sachin Vas on 9/22/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSettingsViewController.h"
#import "GoSettingsOption.h"

@interface GoSettingsViewController ()

@property (nonatomic, strong) NSMutableArray *settingOptions;

@end

@implementation GoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.contentInset = UIEdgeInsetsMake(110, 0, 10, 0);
    
    self.settingOptions = [NSMutableArray array];
    [self configureDataSourceForSelectedMenuItem:0];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)configureDataSourceForSelectedMenuItem:(NSInteger)selectedMenuItem {
    [self.settingOptions removeAllObjects];
    
    GoSettingsOption *logoutOption = [[GoSettingsOption alloc] init];
    logoutOption.imageName = @"";
    logoutOption.optiontext = @"Logout";
    logoutOption.identationLevel = 0;
    [self.settingOptions addObject:logoutOption];
    
    GoSettingsOption *settingsOption = [[GoSettingsOption alloc] init];
    settingsOption.imageName = @"IconSettings";
    settingsOption.optiontext = @"Settings";
    settingsOption.showDisclosureIndicator = YES;
    settingsOption.identationLevel = 0;
    [self.settingOptions addObject:settingsOption];
    
    GoSettingsOption *privacyOption = [[GoSettingsOption alloc] init];
    privacyOption.imageName = @"";
    privacyOption.optiontext = @"Privacy";
    privacyOption.identationLevel = 1;
    if (selectedMenuItem == 1) {
        [self.settingOptions addObject:privacyOption];
    }
    
    GoSettingsOption *profileOption = [[GoSettingsOption alloc] init];
    profileOption.imageName = @"IconProfile";
    profileOption.optiontext = @"Profile";
    profileOption.identationLevel = 1;
    if (selectedMenuItem == 1) {
        [self.settingOptions addObject:profileOption];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.settingOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoSettingsOption *settingOption = [self.settingOptions objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Simple"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Simple"];
    }
    UIColor *backGroundColor = [UIColor colorWithRed:(42.0f/255.0f) green:(159.0f/255.0f) blue:(238.0f/255.0f) alpha:1.0f];
    cell.contentView.backgroundColor = backGroundColor;
    cell.imageView.image = [UIImage imageNamed:settingOption.imageName];
    if (cell.indentationLevel > 0) {
        cell.textLabel.frame = (CGRect){
            .origin = CGPointMake(cell.indentationLevel * 5 + cell.detailTextLabel.frame.origin.x, cell.detailTextLabel.frame.origin.y),
            .size = CGSizeMake(cell.detailTextLabel.frame.size.width - (cell.indentationLevel * 5), cell.detailTextLabel.frame.size.height)};
    }
    cell.textLabel.text = settingOption.optiontext;
    cell.textLabel.textColor = [UIColor whiteColor];
    if (settingOption.shouldShowDisclosureIndicator) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        if ([[self.settingOptions objectAtIndex:indexPath.row] isExpanded]) {
            [self configureDataSourceForSelectedMenuItem:0];
            ((GoSettingsOption *)[self.settingOptions objectAtIndex:indexPath.row]).expanded = NO;
        } else {
            [self configureDataSourceForSelectedMenuItem:1];
            ((GoSettingsOption *)[self.settingOptions objectAtIndex:indexPath.row]).expanded = YES;
        }
        [self.tableView reloadData];
    }
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
