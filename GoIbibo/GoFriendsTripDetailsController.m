//
//  GoFriendsTripDetailsController.m
//  GoIbibo
//
//  Created by Sachin Vas on 10/18/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoFriendsTripDetailsController.h"
#import "GoBusInfoCell.h"
#import <parse/parse.h>
#import "GoUserModelManager.h"
#import "GoContactSyncEntry.h"
#import "GoContactSync.h"

@interface GoFriendsTripDetailsController ()

@property (nonatomic, strong) NSMutableArray *friendsList;

@end

@implementation GoFriendsTripDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsList = [[NSMutableArray alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GoBusInfoCell" bundle:nil] forCellReuseIdentifier:@"FriendsTripsDetailsCellIdentifier"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self checkAndConfigureFriends];
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
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoBusInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsTripsDetailsCellIdentifier" forIndexPath:indexPath];
    
    NSMutableString *sourceDest = [NSMutableString stringWithString:[self.friendsList[indexPath.row] valueForKey:@"source"]];
    [sourceDest appendString:[NSString stringWithFormat:@"--->%@",[self.friendsList[indexPath.row] valueForKey:@"destination"]]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *departureDate = [self.friendsList[indexPath.row] valueForKey:@"departureDate"];
    NSString *dateString = [formatter stringFromDate:departureDate];
    
    cell.travellerName.text = [self.friendsList[indexPath.row] valueForKey:@"passengerName"];
    cell.minimumFare.text = dateString;
    cell.busTypeName.text = sourceDest;
    cell.busTypeName.font = cell.travellerName.font;
    [cell.departureToArrivalTime setHidden:YES];
    [cell.availableSeats setHidden:YES];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  90;
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

- (void)checkAndConfigureFriends {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        PFQuery *query = [PFQuery queryWithClassName:@"BusBookingDetails"];
        [query whereKey:@"departureDate" greaterThanOrEqualTo:[NSDate date]];
        
        NSString *myNumber = [[[GoUserModelManager sharedManager] currentUser] phoneNumber];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            [objects enumerateObjectsUsingBlock:^(PFObject *  _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSString *phoneNo = object[@"bookedUserPhoneNo"];
                
                GoContactSyncEntry *entry =[[[GoContactSync sharedInstance] syncedContacts] valueForKey:phoneNo];
                
                if (entry && ![phoneNo isEqualToString:myNumber]) {
                    
                    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                    for(id key in [object allKeys]) {
                        [mutableDict setValue:object[key] forKey:key];
                    }
                    [mutableDict setValue:entry.name forKey:@"passengerName"];
                    [self.friendsList addObject:mutableDict];
                }
            }];
            
            NSLog(@"Friends count %lu",(unsigned long)self.friendsList.count);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
    });
}


@end
