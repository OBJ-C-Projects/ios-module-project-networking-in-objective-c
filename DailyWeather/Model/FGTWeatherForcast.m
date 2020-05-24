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
        windBearing:(double) deg
                     uvIndex:(int) uvIndex{
    self = [super init];
    
    if(self){
        _time = time;
//        _summary = [summary copy];
        _icon = [icon copy];
        _precipProbability = precipProbability;
        _precipIntensity = precipIntensity;
        _temperature = temperature;
        _apparentTemperature = apparentTemperature;
        _humidity = humidity;
        _pressure = pressure;
        _windSpeed = windSpeed;
        _deg = deg;
        _uvIndex = uvIndex;
    }
    
    return self;
}

//Use to represent the depth levels in the Json
- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    
    NSDictionary *currently = dictionary[@"currently"];
    
    NSNumber *time = currently[@"time"];
    NSString *summary = currently[@"summary"];
    NSString *icon = currently[@"icon"];
    NSNumber *precipProbability = currently[@"precipProbability"];
    NSNumber *precipIntensity = currently[@"precipIntensity"];
    NSNumber *temperature = currently[@"temperature"];
    NSNumber *apparentTemperature = currently[@"apparentTemperature"];
    NSNumber *humidity = currently[@"humidity"];
    NSNumber *pressure = currently[@"pressure"];
    NSNumber *windSpeed = currently[@"windSpeed"];
    NSNumber *deg = currently[@"windBearing"];
    NSNumber *uvIndex = currently[@"currently"];
    
    //Non optionals
    if(!time){
        return nil;
    }
    
    //Optionals
    if([summary isKindOfClass:[NSNull class]]){
        summary = nil;
    }
    if([icon isKindOfClass:[NSNull class]]){
        icon = nil;
    }
    if([precipProbability isKindOfClass:[NSNull class]]){
        precipProbability = nil;
    }
    if([precipIntensity isKindOfClass:[NSNull class]]){
        precipIntensity = nil;
    }
    if([temperature isKindOfClass:[NSNull class]]){
        temperature = nil;
    }
    if([apparentTemperature isKindOfClass:[NSNull class]]){
        apparentTemperature = nil;
    }
    if([humidity isKindOfClass:[NSNull class]]){
        humidity = nil;
    }
    if([pressure isKindOfClass:[NSNull class]]){
        pressure = nil;
    }
    if([windSpeed isKindOfClass:[NSNull class]]){
        windSpeed = nil;
    }
    if([deg isKindOfClass:[NSNull class]]){
        deg = nil;
    }
    if([uvIndex isKindOfClass:[NSNull class]]){
        uvIndex = nil;
    }
    
    //Format date
    double timeInMilliseconds = time.doubleValue;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInMilliseconds / 1000.0];
    
    //Format wind direccion
    NSString *windBearingString = [LSICardinalDirection directionForHeading: deg.doubleValue];
    
    
    return [self initWithTime:date
                       sumary:summary icon:icon precipProbability:precipProbability.intValue precipIntensity:precipIntensity.intValue temperature:temperature.doubleValue apparentTemperature:apparentTemperature.doubleValue
                     humidity:humidity.doubleValue pressure:pressure.doubleValue windSpeed:windSpeed.doubleValue deg:windBearingString uvIndex:uvIndex.intValue];
}


@end
