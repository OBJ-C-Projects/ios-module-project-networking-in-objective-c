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
    
    return nil;
}

@end
