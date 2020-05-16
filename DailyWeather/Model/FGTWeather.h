//
//  FGTWeather.h
//  DailyWeather
//
//  Created by FGT MAC on 5/15/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGTWeather : NSObject


@property (nonatomic, readonly) NSDate *time;
@property (nonatomic, readonly, copy) NSString *summary;
@property (nonatomic, readonly, copy) NSString *icon;
@property (nonatomic, readonly) int precipProbability;
@property (nonatomic, readonly) int precipIntensity;
@property (nonatomic, readonly) double temperature;
@property (nonatomic, readonly) double apparentTemperature;
@property (nonatomic, readonly) double humidity;
@property (nonatomic, readonly) double pressure;
@property (nonatomic, readonly) double windSpeed;
@property (nonatomic, readonly) double windBearing;
@property (nonatomic, readonly) int uvIndex;

- (instancetype)initWithTime:(NSDate *)time
                      sumary:(NSString *)summary
                        icon:(NSString *)icon
           precipProbability:(int) precipProbability
             precipIntensity:(int) precipIntensity
                 temperature:(double) temperature
         apparentTemperature:(double) apparentTemperature
                    humidity:(double) humidity
                    pressure:(double) pressure
                   windSpeed:(double) windSpeed
                 windBearing:(double) windBearing
                     uvIndex:(int) uvIndex;

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
