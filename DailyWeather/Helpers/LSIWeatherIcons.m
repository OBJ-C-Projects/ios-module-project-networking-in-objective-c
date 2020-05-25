//
//  LSIWeatherIcons.m
//
//  Created by Paul Solt on 2/12/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import "LSIWeatherIcons.h"

@interface LSIWeatherIcons ()
    
@end

@implementation LSIWeatherIcons

//New icon id https://openweathermap.org/weather-conditions
+ (NSString *)iconName:(NSNumber*)iconID {
    int iconNum = [iconID intValue];
    switch (iconNum) {
        case 200 ... 232:
            return @"thunderstorm";
        case 300 ... 321:
            return @"Drizzle";
        case 500 ... 531:
            return @"rain";
        case 600 ... 622:
            return @"snow";
        case 701 ... 781:
            return @"fog";
        case 800:
            return @"clear-day";
        case 801 ... 804:
            return @"cloudy";
        default:
             return @"unknown";
            break;
    }
};

+ (UIImage *)weatherImageForIconName:(NSNumber *)iconNumber {
    
    NSString *iconName =  [self iconName:iconNumber];
    
    return [UIImage imageNamed: iconName];;
}

@end
