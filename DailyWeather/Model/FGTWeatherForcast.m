//
//  FGTWeather.m
//  DailyWeather
//
//  Created by FGT MAC on 5/15/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "FGTWeatherForcast.h"
#import "LSICardinalDirection.h"
#import "FGTHourlyForecast.h"


@implementation FGTWeatherForcast


- (instancetype)initWithCity:(NSString *)conditions
                     sunrise:(NSString *) sunrise
                      sunset:(NSString *) sunset
                      iconID:(NSNumber*) iconID
                 temperature:(NSString *) temperature
                   feelsLike:(NSString *) feelsLike
                    humidity:(NSString *) humidity
                    pressure:(NSString *) pressure
                   windSpeed:(NSString *) windSpeed
               windDirection:(NSString *) windDirection
                      hourly:(NSArray *) hourly{
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
        _hourly = hourly;
    }
    
    return self;
}

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    NSDictionary *current = dictionary[@"current"];
    
    NSDictionary *weather = current[@"weather"][0];
    NSNumber *iconNum = weather[@"id"];
    NSString *conditions = weather[@"main"];
    
    //NSDictionary *main = dictionary[@"main"];
    NSNumber *temperature = current[@"temp"];
    NSNumber *feelsLike = current[@"feels_like"];
    NSNumber *humidity = current[@"humidity"];
    NSNumber *pressure = current[@"pressure"];
    
    //NSDictionary *wind = dictionary[@"wind"];
    NSNumber *windSpeed = current[@"speed"];
    NSNumber *windDirection = current[@"deg"];
    
    //NSDictionary *sys = dictionary[@"sys"];
    NSNumber *sunrise = current[@"sunrise"];
    NSNumber *sunset = current[@"sunset"];
    
    NSDictionary *hourly = dictionary[@"hourly"];
    
    
    //Date Format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    //Sunrise time
    NSDate *sunriseTime = [NSDate dateWithTimeIntervalSinceReferenceDate:sunrise.doubleValue];
    NSString *sunriseString = [dateFormatter stringFromDate:sunriseTime];
    
     //Sunset time
    NSDate *sunsetTime = [NSDate dateWithTimeIntervalSinceReferenceDate:sunset.doubleValue];
    NSString *sunsetString =  [dateFormatter stringFromDate: sunsetTime];
    
 
    //Format wind direccion
    NSString *windDirectionString = [LSICardinalDirection directionForHeading: windDirection.doubleValue];
    
    //Check pref for unit format
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    bool isCelciusEnable = [pref boolForKey:@"isCelciusEnable"];
    
    //Format all data to string for label use
    
    //Limit the amount of decimal numbers to zero
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    [formater setMaximum:0];
    [formater setRoundingMode:NSNumberFormatterRoundUp];
    
    
    NSString *tempFormat = isCelciusEnable ? @"°F" : @"°C";
    NSString *temp= [NSString stringWithFormat:@"%@%@",[formater stringFromNumber: temperature], tempFormat];
    NSString *feels = [NSString stringWithFormat:@"%@%@",[formater stringFromNumber: feelsLike],tempFormat];
    
    NSString *speedFormat = isCelciusEnable ? @"mph" : @"km";
    NSString *windSpeedString = [NSString stringWithFormat:@"%@ %@ %@ ", windDirectionString,[formater stringFromNumber: windSpeed],speedFormat];
    
    NSString *humidityString = [NSString stringWithFormat:@"%@%@", humidity,@"%"];
    
    NSString *pressureString = [NSString stringWithFormat:@"%@ inHg",pressure];
    
    
    //TODO: Create the array with hourly data
    NSArray *hourlyArray = [NSArray init];
    
    return [self initWithCity: conditions
                      sunrise:sunriseString
                       sunset:sunsetString
                       iconID: iconNum
                  temperature:temp
                    feelsLike:feels
                     humidity:humidityString
                     pressure:pressureString
                    windSpeed:windSpeedString
                windDirection:windDirectionString
                hourly:hourlyArray];
}


@end
