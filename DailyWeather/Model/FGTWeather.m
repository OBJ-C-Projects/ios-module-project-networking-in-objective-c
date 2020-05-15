//
//  FGTWeather.m
//  DailyWeather
//
//  Created by FGT MAC on 5/15/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "FGTWeather.h"

@implementation FGTWeather

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
                     uvIndex:(int) uvIndex{
    self = [super init];
    
    if(self){
        _time = time;
        _summary = summary;
        _icon = icon;
        _precipProbability = precipProbability;
        _precipIntensity = precipIntensity;
        _temperature = temperature;
        _apparentTemperature = apparentTemperature;
        _humidity = humidity;
        _pressure = pressure;
        _windSpeed = windSpeed;
        _windBearing = windBearing;
        _uvIndex = uvIndex;
    }
    
    return self;
}


@end
