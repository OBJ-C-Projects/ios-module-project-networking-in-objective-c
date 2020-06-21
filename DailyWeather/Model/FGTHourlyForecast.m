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



@end
