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


- (instancetype)initWithCity:(NSString *)city
                     sunrise:(NSDate *) sunrise
                      sunset:(NSDate *) sunset
                      iconID:(NSNumber *) iconID
                 temperature:(double) temperature
                   feelsLike:(double) feelsLike
                    humidity:(double) humidity
                    pressure:(double) pressure
                       speed:(double) windSpeed
               windDirection:(double) windDirection{
    self = [super init];
    
    if(self){
        _city = city;
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
    
    NSString *city = @"name";
    
    NSDictionary *weather = dictionary[@"weather"];
    NSNumber *iconID = weather[@"id"];
    
    NSDictionary *main = dictionary[@"main"];
    NSNumber *temperature = main[@"temp"];
    NSNumber *feelsLike = main[@"feels_like"];
    NSNumber *humidity = main[@"humidity"];
    NSNumber *pressure = main[@"pressure"];
    NSNumber *windSpeed = main[@"speed"];
    NSNumber *windDirection = main[@"deg"];
    
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
    
    
    
    
    
    return [self initWithCity: city
            
                      sunrise:sunriseTime
                       sunset:sunsetTime
                       iconID:iconID
                  temperature:temperature.doubleValue feelsLike:feelsLike.doubleValue
                     humidity:humidity.doubleValue pressure:pressure.doubleValue windSpeed:windSpeed.doubleValue windDirection:windDirectionString.doubleValue];
}


@end
