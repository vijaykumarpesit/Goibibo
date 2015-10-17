//
//  GoHotelViewController.m
//  GoIbibo
//
//  Created by Vijay on 17/10/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoHotelViewController.h"
#import "GOHotelCellCollectionViewCell.h"
#import "GoHotel.h"
#import <AFNetworking/AFNetworking.h>


static NSString *const hotelCellReuseID = @"gohotelcollectionviewcellresuseid";

@interface GoHotelViewController ()

@property (nonatomic, strong) NSMutableArray *hotelDetails;

@end

@implementation GoHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotelDetails = [[NSMutableArray alloc] init];
    [self.hotelCollectionView registerClass:[GOHotelCellCollectionViewCell class] forCellWithReuseIdentifier:hotelCellReuseID];
    self.cityID = @"6123261334828772222";
    self.checkInDate = [NSDate date];
    self.checkoutDate = [[NSDate date] dateByAddingTimeInterval:24*60*60];
    [self fetchHotelDetails];
    
    // Do any additional setup after loading the view from its nib.
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.hotelDetails.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GoHotel *hotel = [self.hotelDetails objectAtIndex:indexPath.row];
    GOHotelCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:hotelCellReuseID forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor whiteColor]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake(mainScreenBounds.size.width,
                      mainScreenBounds.size.height/2);
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
}

- (void)fetchHotelDetails {
    
    NSMutableString *urlString = [NSMutableString stringWithString:[NSString stringWithFormat:@"http://www.goibibo.com/hotels/search-data/?vcid=%@",self.cityID]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];

    NSString *checkInDateString = [formatter stringFromDate:self.checkInDate];
    NSString *checkOutDateString = [formatter stringFromDate:self.checkoutDate];

    [urlString appendString:[NSString stringWithFormat: @"&ci=%@",checkInDateString]];
    [urlString appendString:[NSString stringWithFormat:@"&co=%@",checkOutDateString]];
    [urlString appendString:@"&r=1-1_0&s=popularity&pid=0&flavour=v2&cust=1&ct=b2c&cur=INR"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self saveHotelInfoFromResponseObject:responseObject];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hotelCollectionView reloadData];
    
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Hotel Fetch Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [operation start];

    
}

- (void)saveHotelInfoFromResponseObject:(id)responseObject {
    
    NSArray *data = [responseObject valueForKey:self.cityID];
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GoHotel *hotel = [[GoHotel alloc] init];
        hotel.price = obj[@"prc"];
        hotel.hotelID = obj[@"gohtlid"];
        
        hotel.name = obj[@"hn"];
        
        hotel.lattitude = obj[@"la"];
        hotel.longitude = obj[@"lo"];
        
        hotel.rating = obj[@"gr"];
        hotel.imageURL = obj[@"tbig"];
        [self.hotelDetails addObject:hotel];
    }];
    
}

@end
