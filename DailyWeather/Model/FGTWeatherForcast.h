//
//  FGTWeather.h
//  DailyWeather
//
//  Created by FGT MAC on 5/15/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGTWeatherForcast : NSObject

@property (nonatomic, readonly, copy) NSString *city;
@property (nonatomic, readonly) NSDate *sunrise;
@property (nonatomic, readonly) NSDate *sunset;
@property (nonatomic, readonly) NSNumber *iconID;
@property (nonatomic, readonly) double temperature;
@property (nonatomic, readonly) double feelsLike;
@property (nonatomic, readonly) double humidity;
@property (nonatomic, readonly) double pressure;
@property (nonatomic, readonly) double windSpeed;
@property (nonatomic, readonly) double windDirection;


- (instancetype)initWithCity:(NSString *)city
                     sunrise:(NSDate *) sunrise
                      sunset:(NSDate *) sunset
                      iconID:(NSNumber *) iconID
                 temperature:(double) temperature
                   feelsLike:(double) feelsLike
                    humidity:(double) humidity
                    pressure:(double) pressure
                   windSpeed:(double) windSpeed
               windDirection:(double) windDirection;

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
