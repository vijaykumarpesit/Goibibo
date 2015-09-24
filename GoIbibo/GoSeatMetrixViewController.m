//
//  GoSeatMetrixViewController.m
//  GoIbibo
//
//  Created by Vijay on 24/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoSeatMetrixViewController.h"
#import "GoSeatCollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import "GoBusSeatLayout.h"
#import "GoPaymentConfirmation.h"

@interface GoSeatMetrixViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *seats;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UILabel *searchingLabel;
@property (nonatomic, strong) GoBusDetails *busDetails;
@property (nonatomic, strong) NSString *seatNoReservedByFriend;

@end

@implementation GoSeatMetrixViewController

- (instancetype)initWithBusDetails:(GoBusDetails *)busDetails seatNoReservedByFriend:(NSString *)seatNo {

    self = [super initWithNibName:@"GoSeatMetrixViewController" bundle:nil];
    if (self) {
        self.busDetails = busDetails;
        self.seatNoReservedByFriend = seatNo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seats = [[NSMutableArray alloc] init];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoSeatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"busSeatCell"];
    [self loadBusLayoutMetrix];
    [self.collectionView setHidden:YES];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.seats.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoSeatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"busSeatCell" forIndexPath:indexPath];
    GoBusSeatLayout *layout = [self.seats objectAtIndex:indexPath.row];
    cell.seatNo.text = layout.seatNo;
    [cell.backgroundImageView setHidden:YES];
    
    if(layout.seatNo && [layout.seatNo isEqualToString:self.seatNoReservedByFriend]){
        cell.seatNo.text = layout.seatNo;
        [cell.backgroundImageView setHidden:NO];
        
    }else if (!layout.isSeatAvailable) {
        [cell setBackgroundColor:[UIColor redColor]];
    } else {
        [cell setBackgroundColor:[UIColor greenColor]];
        
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake(mainScreenBounds.size.width/3 -2,
                      mainScreenBounds.size.width/2.5) ;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    GoBusSeatLayout *layout = [self.seats objectAtIndex:indexPath.row];
    if (layout.isSeatAvailable) {
        GoPaymentConfirmation *paymentVC = [[GoPaymentConfirmation alloc] initWithBusDetails:self.busDetails withSeatNo:layout.seatNo];
        [self.navigationController pushViewController:paymentVC animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Seat Not Avialble" message:@"Please Select other" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

}

- (void)loadBusLayoutMetrix {
 
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://developer.goibibo.com/api/bus/seatmap/?app_id=abfac0dc&app_key=5368f504b75224601dccebd153275543&format=json"];
    
    [urlString appendString:[NSString stringWithFormat:@"&skey=%@",self.busDetails.skey]];
    urlString = (NSMutableString *) [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveBusSeatLayoutFromResponseObject:responseObject];
        
        if (self.seats.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No of seats retuned by API is 0" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.collectionView setHidden:NO];
        [self.searchingLabel setHidden:YES];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in Fetching seat matrix" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [operation start];
}

- (void)saveBusSeatLayoutFromResponseObject:(id)responseObject {
    
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSArray *busSeats = [data valueForKey:@"onwardSeats"];
    
    for(id busSeat in busSeats) {
        GoBusSeatLayout *busSeatLayout = [[GoBusSeatLayout alloc] init];
        busSeatLayout.seatNo = busSeat[@"SeatName"];
        NSNumber *seatStstusValue = busSeat[@"SeatStatus"];
        busSeatLayout.isSeatAvailable = seatStstusValue.boolValue;
        [self.seats addObject:busSeatLayout];
    }
    
    NSLog(@"SuccessFully Parserd and saved the results in correct format");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
