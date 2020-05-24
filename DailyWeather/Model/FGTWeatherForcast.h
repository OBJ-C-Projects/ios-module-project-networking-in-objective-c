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

@property (nonatomic, readonly, copy) NSString *name;//city
@property (nonatomic, readonly, copy) NSString *id;//icon id https://openweathermap.org/weather-conditions
@property (nonatomic, readonly) double temp;
@property (nonatomic, readonly) double feels_like;
@property (nonatomic, readonly) double humidity;
@property (nonatomic, readonly) double pressure;
@property (nonatomic, readonly) double speed;//Wind speed
@property (nonatomic, readonly) double deg;//Wind direction
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
