//
//  FGTHourlyForecast.m
//  EZWeather
//
//  Created by FGT MAC on 6/21/20.
//  Copyright © 2020 Fritz Gamboa. All rights reserved.
//

#import "FGTHourlyForecast.h"

@implementation FGTHourlyForecast


- (instancetype)initWithTemp:(NSString *)temp
                          dt:(NSString *) dt
                      iconID:(NSNumber *) iconID{
    
    self = [super init];
    
    if(self){
        _temp = temp;
        _dt = dt;
        _iconID = iconID;
    }
    
    return self;
}

- (instancetype)initWithDictionary: (NSDictionary *) dictionary{
    
    //Extrating JSON
    NSDictionary *weather = dictionary[@"weather"][0];
    NSNumber *iconNum = weather[@"id"];
    
    NSNumber *temperature = dictionary[@"temp"];
    
    NSNumber *dt = dictionary[@"dt"];
    
    //Formating data
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    
    //Temperature and formater
    NSNumberFormatter *formater = [[NSNumberFormatter alloc] init];
    [formater setMaximum:0];
    [formater setRoundingMode:NSNumberFormatterRoundUp];
    
    NSString *tempString = [NSString stringWithFormat:@"%@°", [formater stringFromNumber:temperature]];
    
    
    //Current time
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceReferenceDate: dt.doubleValue];
    NSString *currentTimeString = [dateFormatter stringFromDate:currentTime];
    
    return [self initWithTemp: tempString
                           dt:currentTimeString
                       iconID: iconNum
            ];
}

@end
