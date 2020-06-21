//
//  FGTHourlyForecast.h
//  EZWeather
//
//  Created by FGT MAC on 6/21/20.
//  Copyright © 2020 Fritz Gamboa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGTHourlyForecast : NSObject

@property (nonatomic,readonly,copy) NSString *temp;
@property (nonatomic,readonly,copy) NSString *dt;
@property (nonatomic, readonly) NSNumber *iconID;


- (instancetype)initWithTemp:(NSString *)temp
                          dt:(NSString *) dt
                      iconID:(NSNumber *) iconID;

@end

NS_ASSUME_NONNULL_END
