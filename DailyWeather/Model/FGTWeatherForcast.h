//
//  FGTWeather.h
//  DailyWeather
//
//  Created by FGT MAC on 5/15/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FGTHourlyForecast;

NS_ASSUME_NONNULL_BEGIN

@interface FGTWeatherForcast : NSObject

@property (nonatomic, readonly, copy) NSString *conditions;
@property (nonatomic, readonly, copy) NSString *sunrise;
@property (nonatomic, readonly, copy) NSString *sunset;
@property (nonatomic, readonly, copy) NSString *icon;
@property (nonatomic, readonly, copy) NSString *temperature;
@property (nonatomic, readonly, copy) NSString *feelsLike;
@property (nonatomic, readonly, copy) NSString *humidity;

//Conver to get chances or rain and
@property (nonatomic, readonly, copy) NSString *pressure;
@property (nonatomic, readonly, copy) NSString *windSpeed;
@property (nonatomic, readonly, copy) NSString *windDirection;

@property (nonatomic, readonly, copy) NSMutableArray<FGTHourlyForecast *> *hourly;



- (instancetype)initWithCity:(NSString *)conditions
                     sunrise:(NSString *) sunrise
                      sunset:(NSString *) sunset
                      icon:(NSString *) icon
                 temperature:(NSString *) temperature
                   feelsLike:(NSString *) feelsLike
                    humidity:(NSString *) humidity
                    pressure:(NSString *) pressure
                   windSpeed:(NSString *) windSpeed
               windDirection:(NSString *) windDirection
                hourly:(NSMutableArray *) hourly;

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
