//
//  ViewController.m
//  GoIbibo
//
//  Created by Vijay on 22/09/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import "GoHomeViewController.h"
#import "GoLayoutHandler.h"

@interface GoHomeViewController ()

@end

@implementation GoHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"KWRU";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left-side-bar-hamburger.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemPressed:)];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftBarButtonItemPressed:(id)sender {
    [[[GoLayoutHandler sharedInstance] sideMenu] presentLeftMenuViewController];
}

//Implement this 
-(void)digitsAuthenticationFinishedWithSession:(DGTSession *)aSession error:(NSError *)error {
 
}


@end
