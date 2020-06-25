//
//  FGTFetchWeatherData.h
//  EZWeather
//
//  Created by FGT MAC on 6/25/20.
//  Copyright © 2020 Fritz Gamboa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FGTWeatherForcast.h"

NS_ASSUME_NONNULL_BEGIN

@interface FGTFetchWeatherData : NSObject


+ (void)requestWeather:(CLLocation *)location isCelciusEnable:(bool)isCelciusEnable completion:(void (^)(FGTWeatherForcast *data, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
