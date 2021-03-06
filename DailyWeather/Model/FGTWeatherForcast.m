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
#import "FGTDailyForecast.h"

@implementation FGTWeatherForcast


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
                      hourly:(NSMutableArray *) hourly
                       daily: (NSMutableArray *) daily{
    self = [super init];
    
    if(self){
        _conditions = conditions;
        _sunrise = sunrise;
        _sunset = sunset;
        _icon = icon;
        _temperature = temperature;
        _feelsLike = feelsLike;
        _humidity = humidity;
        _pressure = pressure;
        _windSpeed = windSpeed;
        _windDirection = windDirection;
        _hourly = hourly;
        _daily = daily;
    }
    
    return self;
}

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    NSDictionary *current = dictionary[@"current"];
    
    NSDictionary *weather = current[@"weather"][0];
    NSString *iconNum = weather[@"icon"];
    NSString *conditions = weather[@"main"];
    
    //NSDictionary *main = dictionary[@"main"];
    NSNumber *temperature = current[@"temp"];
    NSNumber *feelsLike = current[@"feels_like"];
    NSNumber *humidity = current[@"humidity"];
    NSNumber *pressure = current[@"pressure"];
    
    //NSDictionary *wind = dictionary[@"wind"];
    NSNumber *windSpeed = current[@"wind_speed"];
    NSNumber *windDirection = current[@"wind_deg"];
    
    //NSDictionary *sys = dictionary[@"sys"];
    NSNumber *sunrise = current[@"sunrise"];
    NSNumber *sunset = current[@"sunset"];
    
    
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
    
    
    NSString *tempFormat = isCelciusEnable ? @"°C" : @"°F";
    NSString *temp= [NSString stringWithFormat:@"%@%@",[formater stringFromNumber: temperature], tempFormat];
    NSString *feels = [NSString stringWithFormat:@"%@%@",[formater stringFromNumber: feelsLike],tempFormat];
    
    NSString *speedFormat = isCelciusEnable ? @"km/h" : @"mph";
    NSString *windSpeedString = [NSString stringWithFormat:@"%@ %@ %@ ", windDirectionString,[formater stringFromNumber: windSpeed],speedFormat];
    
    NSString *humidityString = [NSString stringWithFormat:@"%@%@", humidity,@"%"];
    
    NSString *pressureString = [NSString stringWithFormat:@"%@ inHg",pressure];
    
    
    
    //Setup array for the next 24hr forecast
    NSMutableArray<FGTHourlyForecast *> *hourlyArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 24; i++) {
        NSDictionary *hourly = dictionary[@"hourly"][i];
        FGTHourlyForecast *hourlyForeCast = [[FGTHourlyForecast alloc] initWithDictionary: hourly];
        [hourlyArray addObject:hourlyForeCast];
    }
    
    //Setup array for the daily forecast
    NSMutableArray<FGTDailyForecast *> *dailyArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i++){
        NSDictionary *daily = dictionary[@"daily"][i];
        FGTDailyForecast *dailyForecast = [[FGTDailyForecast alloc] initWithDictionary:daily];
        [dailyArray addObject: dailyForecast];
    }
    
    
    return [self initWithCity: conditions
                      sunrise:sunriseString
                       sunset:sunsetString
                       icon: iconNum
                  temperature:temp
                    feelsLike:feels
                     humidity:humidityString
                     pressure:pressureString
                    windSpeed:windSpeedString
                windDirection:windDirectionString
                hourly:hourlyArray
                daily: dailyArray];
}


@end
