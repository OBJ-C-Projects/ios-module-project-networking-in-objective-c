//
//  FGTWeather.m
//  DailyWeather
//
//  Created by FGT MAC on 5/15/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "FGTWeatherForcast.h"
#import "LSICardinalDirection.h"

@implementation FGTWeatherForcast


- (instancetype)initWithCity:(NSString *)conditions
                     sunrise:(NSDate *) sunrise
                      sunset:(NSDate *) sunset
                      iconID:(NSNumber *) iconID
                 temperature:(NSString *) temperature
                   feelsLike:(NSString *) feelsLike
                    humidity:(NSString *) humidity
                    pressure:(NSString *) pressure
                   windSpeed:(NSString *) windSpeed
               windDirection:(NSString *) windDirection{
    self = [super init];
    
    if(self){
        _conditions = conditions;
        _sunrise = sunrise;
        _sunset = sunset;
        _iconID = iconID;
        _temperature = temperature;
        _feelsLike = feelsLike;
        _humidity = humidity;
        _pressure = pressure;
        _windSpeed = windSpeed;
        _windDirection = windDirection;
    }
    
    return self;
}

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    NSDictionary *weather = dictionary[@"weather"][0];
    NSNumber *iconID = weather[@"id"];
    NSString *conditions = weather[@"main"];
    
    NSDictionary *main = dictionary[@"main"];
    NSNumber *temperature = main[@"temp"];
    NSNumber *feelsLike = main[@"feels_like"];
    NSNumber *humidity = main[@"humidity"];
    NSNumber *pressure = main[@"pressure"];
    
    NSDictionary *wind = dictionary[@"wind"];
    NSNumber *windSpeed = wind[@"speed"];
    NSNumber *windDirection = wind[@"deg"];
    
    NSDictionary *sys = dictionary[@"sys"];
    NSNumber *sunrise = sys[@"sunrise"];
    NSNumber *sunset = sys[@"sunset"];
    
    
    //Time Format
    double sunriseInMilliseconds = sunrise.doubleValue;
    NSDate *sunriseTime = [NSDate dateWithTimeIntervalSince1970:sunriseInMilliseconds / 1000.0];
    
    double sunsetInMilliseconds = sunset.doubleValue;
    NSDate *sunsetTime = [NSDate dateWithTimeIntervalSince1970:sunsetInMilliseconds / 1000.0];
    
    //Format wind direccion
    NSString *windDirectionString = [LSICardinalDirection directionForHeading: windDirection.doubleValue];
    
    
    //Format all data to string for label use
    
    //Limit the amount of decimal numbers to zero
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    [formater setMaximum:0];
    [formater setRoundingMode:NSNumberFormatterRoundUp];
    
    NSString *temp= [NSString stringWithFormat:@"%@°F",[formater stringFromNumber: temperature]];
    NSString *feels = [NSString stringWithFormat:@"%@°F",[formater stringFromNumber: feelsLike]];
    
    NSString *windSpeedString = [NSString stringWithFormat:@"%@ %@ mph", windDirectionString,[formater stringFromNumber: windSpeed]];
    
    NSString *humidityString = [NSString stringWithFormat:@"%@%@", humidity,@"%"];
    
    NSString *pressureString = [NSString stringWithFormat:@"%@ inHg",pressure];
    
    
    
    return [self initWithCity: conditions
                      sunrise:sunriseTime
                       sunset:sunsetTime
                       iconID:iconID
                  temperature:temp
                    feelsLike:feels
                     humidity:humidityString
                     pressure:pressureString
                    windSpeed:windSpeedString
                windDirection:windDirectionString];
}


@end
