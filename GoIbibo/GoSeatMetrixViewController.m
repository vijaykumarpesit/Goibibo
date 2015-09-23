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


@interface GoSeatMetrixViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *seats;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSString *skey;

@end

@implementation GoSeatMetrixViewController

- (instancetype)initWithBusSkey:(NSString *)skey {

    self = [super initWithNibName:@"GoSeatMetrixViewController" bundle:nil];
    if (self) {
        self.skey = skey;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seats = [[NSMutableArray alloc] init];
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoSeatCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"busSeatCell"];
    [self loadBusLayoutMetrix];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.seats.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoSeatCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"busSeatCell" forIndexPath:indexPath];
    GoBusSeatLayout *layout = [self.seats objectAtIndex:indexPath.row];
    cell.seatNo.text = layout.seatNo;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGRect mainScreenBounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake(mainScreenBounds.size.width/3 -2,
                      mainScreenBounds.size.width/2.5) ;
}

- (void)loadBusLayoutMetrix {
 
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://developer.goibibo.com/api/bus/seatmap/?app_id=abfac0dc&app_key=5368f504b75224601dccebd153275543&format=json"];
    
    [urlString appendString:[NSString stringWithFormat:@"&skey=%@",self.skey]];
    urlString = (NSMutableString *) [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveBusSeatLayoutFromResponseObject:responseObject];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operation start];
}

- (void)saveBusSeatLayoutFromResponseObject:(id)responseObject {
    
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSArray *busSeats = [data valueForKey:@"onwardSeats"];
    
    for(id busSeat in busSeats) {
        GoBusSeatLayout *busSeatLayout = [[GoBusSeatLayout alloc] init];
        busSeatLayout.seatNo = busSeat[@"SeatName"];
        [self.seats addObject:busSeatLayout];
    }
    
    NSLog(@"SuccessFully Parserd and saved the results in correct format");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
