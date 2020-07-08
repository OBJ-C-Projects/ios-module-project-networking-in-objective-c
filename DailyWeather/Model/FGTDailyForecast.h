//
//  FGTDailyForecast.h
//  DailyWeather
//
//  Created by FGT MAC on 5/16/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FGTDailyForecast : NSObject

@property (nonatomic, readonly, copy) NSString *dt;
@property (nonatomic, readonly,copy) NSString *min;
@property (nonatomic, readonly, copy) NSString *max;

- (instancetype)initWithDt:(NSString *)dt
                       min:(NSString *)min
                       max:(NSString *)max;

- (instancetype)initWithDictionary: (NSDictionary *) dictionary;

@end

NS_ASSUME_NONNULL_END
