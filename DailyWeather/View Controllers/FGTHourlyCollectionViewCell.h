//
//  FGTHourlyCollectionViewCell.h
//  DailyWeather
//
//  Created by FGT MAC on 6/19/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGTHourlyCollectionViewCell : UICollectionViewCell

@property (strong,nonatomic) IBOutlet UILabel *time;
@property (strong,nonatomic) IBOutlet UILabel *temperature;
@property (strong,nonatomic) IBOutlet UIImageView *image;


@end

NS_ASSUME_NONNULL_END
