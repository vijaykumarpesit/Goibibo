//
//  GOHotelCellCollectionViewCell.h
//  GoIbibo
//
//  Created by Vijay on 17/10/15.
//  Copyright © 2015 Vijay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GOHotelCellCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *ratings;
@property (nonatomic, weak) NSString *imageURL;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *friendNameView;
@property (weak, nonatomic) IBOutlet UIButton *bookButton;

@end
