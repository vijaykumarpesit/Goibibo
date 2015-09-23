//
//  GoBusListViewController.m
//  
//
//  Created by Vijay on 23/09/15.
//
//

#import "GoBusListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "GoBusDetails.h"
#import "GoBusInfoCell.h"
#import "GoSeatMetrixViewController.h"

@interface GoBusListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *destination;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *arrivalDate;
@property (nonatomic, strong) NSMutableArray *busResults;
@property (nonatomic, strong) IBOutlet UILabel *searchingLabel;
@end

@implementation GoBusListViewController

- (instancetype)initWithSource:(NSString *)source
                   destination:(NSString *)destination
                 departureDate:(NSDate *)departureDate
                   arrivalDate:(NSDate *)arrivalDate {
    self = [super initWithNibName:@"GoBusListViewController" bundle:nil];
    if (self) {
        self.source = source;
        self.destination = destination;
        self.departureDate = [NSDate date];
        self.arrivalDate = arrivalDate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@ to %@", [self.source capitalizedString], [self.destination capitalizedString]];
    self.busResults = [[NSMutableArray alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoBusInfoCell" bundle:nil] forCellReuseIdentifier:@"busInfoCell"];
    [self loadDataFromGoIBibo];
    [self.tableView setHidden:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.busResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoBusInfoCell *busInfoCell = [tableView dequeueReusableCellWithIdentifier:@"busInfoCell"];
    GoBusDetails *busDetails = [self.busResults objectAtIndex:indexPath.row];
    
    busInfoCell.travellerName.text = busDetails.travelsName;
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ -->%@",busDetails.departureTime,busDetails.arrivalTime] attributes:nil];
    [mutableAttributedString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0f]} range:NSMakeRange(0, busDetails.departureTime.length + 4)];
    busInfoCell.departureToArrivalTime.attributedText = mutableAttributedString;
    busInfoCell.minimumFare.text = [NSString stringWithFormat:@"\u20B9%@",busDetails.minimumFare];
    busInfoCell.availableSeats.text = [NSString stringWithFormat:@"%@ seats", busDetails.noOfSeatsAvailable];
    busInfoCell.busTypeName.text= busDetails.busType;
    return busInfoCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    GoBusDetails *busDetails = [self.busResults objectAtIndex:indexPath.row];
    GoSeatMetrixViewController *metrixVC = [[GoSeatMetrixViewController alloc] initWithBusSkey:busDetails.skey];
    [self.navigationController pushViewController:metrixVC animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"None of your friends have booked through this root yet"];
}

- (void)loadDataFromGoIBibo {
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://developer.goibibo.com/api/bus/search/?app_id=abfac0dc&app_key=5368f504b75224601dccebd153275543&format=json"];
    
    [urlString appendString:[NSString stringWithFormat:@"&source=%@",self.source]];
    [urlString appendString:[NSString stringWithFormat:@"&destination=%@",self.destination]];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    [dateformate setDateFormat:@"yyyyMMdd"];
    NSString *departureDateString = [dateformate stringFromDate:self.departureDate];
    [urlString appendString:[NSString stringWithFormat:@"&dateofdeparture=%@",departureDateString]];
    
    if (self.arrivalDate) {
        NSDateFormatter *dateformate=[[NSDateFormatter alloc] init];
        [dateformate setDateFormat:@"yyyyMMdd"];
        NSString *arrivalDateString = [dateformate stringFromDate:self.arrivalDate];
        [urlString appendString:[NSString stringWithFormat:@"&dateofarrival=%@",arrivalDateString]];
    }
    
    urlString = (NSMutableString *) [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [self saveBusInfoFromResponseObject:responseObject];
        [self.tableView setHidden:NO];
        [self.searchingLabel setHidden:YES];
        
        if (self.busResults.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No of buses retuned by API is 0" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Bus fetch failed " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    [operation start];
}

- (void)saveBusInfoFromResponseObject:(id)responseObject {
    
    NSDictionary *data = [responseObject valueForKey:@"data"];
    NSArray *onwardBuses = [data valueForKey:@"onwardflights"];
    
    for(id bus in onwardBuses) {
        GoBusDetails  *busDetails = [[GoBusDetails alloc] init];
        busDetails.travelsName = bus[@"TravelsName"];
        busDetails.busType = bus[@"BusType"];
        busDetails.departureTime = bus[@"DepartureTime"];
        busDetails.arrivalTime = bus[@"ArrivalTime"];
        busDetails.rowID = bus[@"rowid"];
        busDetails.skey = bus[@"skey"];
        
        NSDictionary *routeSeatTypeDetail = bus[@"RouteSeatTypeDetail"];
        NSArray *list = routeSeatTypeDetail[@"list"];
        NSDictionary *seatDict = [list firstObject];
        busDetails.noOfSeatsAvailable = seatDict[@"SeatsAvailable"];
        
        NSDictionary *fare = bus[@"fare"];
        NSNumber *fareValue = fare[@"totalfare"];
        busDetails.minimumFare = [NSString stringWithFormat:@"%@", fareValue];
        
        NSDictionary *feedback = bus[@"feedback"];
        NSNumber *ratingsValue = feedback[@"rating"];
        busDetails.ratings = [NSString stringWithFormat:@"%@", ratingsValue];
        [self.busResults addObject:busDetails];
    }
    
    NSLog(@"SuccessFully Parserd and saved the results in correct format");
}

@end
