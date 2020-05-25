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

@property (nonatomic, readonly, copy) NSString *conditions;
@property (nonatomic, readonly) NSDate *sunrise;
@property (nonatomic, readonly) NSDate *sunset;
@property (nonatomic, readonly) NSNumber *iconID;
@property (nonatomic, readonly, copy) NSString *temperature;
@property (nonatomic, readonly, copy) NSString *feelsLike;
@property (nonatomic, readonly, copy) NSString *humidity;
@property (nonatomic, readonly, copy) NSString *pressure;
@property (nonatomic, readonly, copy) NSString *windSpeed;
@property (nonatomic, readonly, copy) NSString *windDirection;


- (instancetype)initWithCity:(NSString *)conditions
                     sunrise:(NSDate *) sunrise
                      sunset:(NSDate *) sunset
                      iconID:(NSNumber *) iconID
                 temperature:(NSString *) temperature
                   feelsLike:(NSString *) feelsLike
                    humidity:(NSString *) humidity
                    pressure:(NSString *) pressure
                   windSpeed:(NSString *) windSpeed
               windDirection:(NSString *) windDirection;

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
