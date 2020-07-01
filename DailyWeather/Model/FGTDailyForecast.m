//
//  FGTDailyForecast.m
//  DailyWeather
//
//  Created by FGT MAC on 5/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "FGTDailyForecast.h"

@implementation FGTDailyForecast

- (instancetype)initWithDt:(NSString *)dt
                       min:(NSString *)min
                       max:(NSString *)max{
    self = [super init];
    
    if (self){
        _dt = dt;
        _min = min;
        _max = max;
    }
    return self;
}


- (instancetype)initWithDictionary: (NSDictionary *) dictionary{
    
    //Extracting JSON
    NSNumber *date = dictionary[@"dt"];
    
    NSDictionary *temp = dictionary[@"temp"];
    
    NSDictionary *min = temp[@"min"];
    NSDictionary *max = temp[@"max"];
    
    //Formating Extracted data
    
    //1.Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate *currentTime = [NSDate dateWithTimeIntervalSinceReferenceDate:date.doubleValue];
    NSString *dateString = [dateFormatter stringFromDate:currentTime];
    
    //2.Temperature
    
    
    return nil;
}

@end
