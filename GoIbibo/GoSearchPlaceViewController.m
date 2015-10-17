//
//  GoSearchPlaceViewController.m
//  GoIbibo
//
//  Created by Sachin Vas on 9/24/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSearchPlaceViewController.h"

@interface GoSearchPlaceViewController () <UISearchBarDelegate>

@property (nonatomic, copy) NSString *selectedPlace;
@property (nonatomic, strong) NSMutableDictionary *placeDictionary;
@property (nonatomic, strong) NSMutableDictionary *searchPlaceDictionary;
@property (nonatomic) BOOL isSearching;
@property (weak, nonatomic) IBOutlet UISearchBar *seachBar;

@end

@implementation GoSearchPlaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    _placeDictionary = [NSMutableDictionary dictionary];
    _searchPlaceDictionary = [NSMutableDictionary dictionary];
    [_placeDictionary setObject:@"Bangalore" forKey:@"1001"];
    [_placeDictionary setObject:@"Chennai" forKey:@"1002"];
    [_placeDictionary setObject:@"Hyderabad" forKey:@"1003"];
    [_placeDictionary setObject:@"Sirsi" forKey:@"1004"];
    [_placeDictionary setObject:@"Kollam" forKey:@"1005"];
    [_placeDictionary setObject:@"Mandya" forKey:@"1006"];
    [_placeDictionary setObject:@"Mumbai" forKey:@"1007"];
    [_placeDictionary setObject:@"Pondicherry" forKey:@"1008"];
    [_placeDictionary setObject:@"Mysore" forKey:@"1009"];
    [_placeDictionary setObject:@"Hubli" forKey:@"10010"];

    self.seachBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightBarButtonItemPressed:)];
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = self.isSourcePlace ? @"Seach Source Places" : @"Search Destination Places";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)rightBarButtonItemPressed:(id)sender {
    self.updateSelectedPlace(self.selectedPlace);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
        return self.searchPlaceDictionary.count;
    }
    return self.placeDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchPlace"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchPlace"];
    }
    if (self.isSearching) {
        cell.textLabel.text = [self.searchPlaceDictionary allValues][indexPath.row];
    } else {
        cell.textLabel.text = [self.placeDictionary allValues][indexPath.row];
    }
    if ([self.selectedPlace isEqualToString:cell.textLabel.text]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isSearching) {
        self.selectedPlace = [self.searchPlaceDictionary allValues][indexPath.row];
    } else {
        self.selectedPlace = [self.placeDictionary allValues][indexPath.row];
    }
    [self rightBarButtonItemPressed:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    _isSearching = YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    _searchPlaceDictionary = [[[self.placeDictionary allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText]] mutableCopy];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _isSearching = NO;
}

@end
