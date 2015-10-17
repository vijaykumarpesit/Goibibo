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
    [_placeDictionary setObject:@"Chennai" forKey:@"4354390963378411938"];
    [_placeDictionary setObject:@"Hyderabad" forKey:@"2162254155836171767"];
    [_placeDictionary setObject:@"New Delhi" forKey:@"2820046943342890302"];
    [_placeDictionary setObject:@"Kollam" forKey:@"9181313283980120876"];
    [_placeDictionary setObject:@"Mandya" forKey:@"488538077236154664"];
    [_placeDictionary setObject:@"Mumbai" forKey:@"1914808440588557366"];
    [_placeDictionary setObject:@"Pondicherry" forKey:@"7247861711286471145"];
    [_placeDictionary setObject:@"Mysore" forKey:@"6237241643285427714"];
    [_placeDictionary setObject:@"Hubli" forKey:@"4175146706007535451"];
    [_placeDictionary setObject:@"Gangotri" forKey:@"5001619947363078572"];
    [_placeDictionary setObject:@"Mantralayam" forKey:@"6123261334828772222"];
    [_placeDictionary setObject:@"Shimla" forKey:@"1449073512565742573"];
    [_placeDictionary setObject:@"Mumbai" forKey:@"4213513766539949483"];
    [_placeDictionary setObject:@"Lumbini" forKey:@"547330913285903480"];
    [_placeDictionary setObject:@"Jodhpur" forKey:@"2455265397967176363"];
    [_placeDictionary setObject:@"Badami" forKey:@"767346164151916001"];
    [_placeDictionary setObject:@"Kolkata" forKey:@"2066465017672827882"];
    [_placeDictionary setObject:@"Pune" forKey:@"1554245012668028405"];
    [_placeDictionary setObject:@"Mangalore" forKey:@"8122644638120735625"];
    [_placeDictionary setObject:@"Nawalgarh" forKey:@"2702997798690416798"];
    [_placeDictionary setObject:@"Gandhinagar" forKey:@"6413353945126501356"];
    [_placeDictionary setObject:@"Mathura" forKey:@"33265771996272232"];
    [_placeDictionary setObject:@"Rajkot" forKey:@"7030802527799619237"];
    [_placeDictionary setObject:@"Srikalahasti" forKey:@"7526624291853629500"];
    [_placeDictionary setObject:@"Bijapur" forKey:@"7116969506857242754"];
    [_placeDictionary setObject:@"Belgaum" forKey:@"2315788948560750093"];
    [_placeDictionary setObject:@"Jamshedpur" forKey:@"8399297392482907494"];
    [_placeDictionary setObject:@"Malpe" forKey:@"4627994955829376023"];
    [_placeDictionary setObject:@"B.R. Hills" forKey:@"2143034057251484444"];
    [_placeDictionary setObject:@"Patiala" forKey:@"436861998287687173"];
    [_placeDictionary setObject:@"Kushinagar" forKey:@"1054157661196671846"];
    [_placeDictionary setObject:@"Nilagiri" forKey:@"4781203545819888306"];
    [_placeDictionary setObject:@"Ahmedabad" forKey:@"7783787037713615543"];
    [_placeDictionary setObject:@"Ahmedabad" forKey:@"6067246467661897899"];
    [_placeDictionary setObject:@"Chikmagalur" forKey:@"4801527334652294087"];
    [_placeDictionary setObject:@"Gorakhpur" forKey:@"2496493766324838012"];
    [_placeDictionary setObject:@"Hassan" forKey:@"4013299611085558956"];
    [_placeDictionary setObject:@"Guntur" forKey:@"5456312398449971170"];
    [_placeDictionary setObject:@"Kolhapur" forKey:@"3931060669256740310"];
    [_placeDictionary setObject:@"Bangalore" forKey:@"6771549831164675055"];
    [_placeDictionary setObject:@"Mettupalayam" forKey:@"1760301079813577051"];
    [_placeDictionary setObject:@"Pantnagar" forKey:@"8702978431111111111"];
    [_placeDictionary setObject:@"Shimoga" forKey:@"2510520520918709430"];
    [_placeDictionary setObject:@"Shivanasamudra" forKey:@"488538077236155555"];
    [_placeDictionary setObject:@"Coonoor" forKey:@"3082172792776588665"];
    [_placeDictionary setObject:@"Greater Noida" forKey:@"2351986185065628184"];
    [_placeDictionary setObject:@"Kanchipuram" forKey:@"7943316035636087193"];
  

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
    if (self.isSearching && self.seachBar.text.length > 0) {
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
    NSArray *searchedObjects = [[self.placeDictionary allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self CONTAINS[cd] %@", searchText]];
    [_searchPlaceDictionary removeAllObjects];
    for (NSString *value in searchedObjects) {
        [_searchPlaceDictionary setObject:value forKey:[self.placeDictionary allKeysForObject:value]];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    _isSearching = NO;
}

@end
