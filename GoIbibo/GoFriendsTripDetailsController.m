//
//  GoFriendsTripDetailsController.m
//  GoIbibo
//
//  Created by Sachin Vas on 10/18/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoFriendsTripDetailsController.h"
#import "GoBusInfoCell.h"

@interface GoFriendsTripDetailsController ()

@property (nonatomic, strong) NSMutableArray *friendsTripsDetails;

@end

@implementation GoFriendsTripDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoBusInfoCell" bundle:nil] forCellReuseIdentifier:@"FriendsTripsDetailsCellIdentifier"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return self.friendsTripsDetails.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoBusInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsTripsDetailsCellIdentifier" forIndexPath:indexPath];
    
    cell.travellerName.text = [self.friendsTripsDetails[indexPath.row] valueForKey:@""];
    cell.minimumFare.text = [self.friendsTripsDetails[indexPath.row] valueForKey:@""];
    cell.busTypeName.text = [self.friendsTripsDetails[indexPath.row] valueForKey:@""];
    return cell;
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
