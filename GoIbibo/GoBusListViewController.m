//
//  GoBusListViewController.m
//  
//
//  Created by Vijay on 23/09/15.
//
//

#import "GoBusListViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface GoBusListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation GoBusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDataFromGoIBibo];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDataFromGoIBibo {
    
    //TODO:Devide this in to base url and make sure values are configurable 
    NSString *urlString = @"http://developer.goibibo.com/api/bus/search/?app_id=abfac0dc&app_key=5368f504b75224601dccebd153275543&format=json&source=bangalore&destination=hyderabad&dateofdeparture=20150930";
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    }];
    
    [operation start];
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
