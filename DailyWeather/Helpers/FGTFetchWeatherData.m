//
//  FGTFetchWeatherData.m
//  EZWeather
//
//  Created by FGT MAC on 6/25/20.
//  Copyright © 2020 Fritz Gamboa. All rights reserved.
//

#import "FGTFetchWeatherData.h"
#import "FGTWeatherForcast.h"

@implementation FGTFetchWeatherData

+ (void)requestWeather:(CLLocation *)location isCelciusEnable:(bool)isCelciusEnable completion:(void (^)(FGTWeatherForcast *data, NSError *error))completion{
    
    // TODO: 1. Parse CurrentWeather.json from App Bundle and update UI
    //Base URL: https://openweathermap.org/current
    NSString *baseURL = @"https://api.openweathermap.org/data/2.5/onecall?";
    
    NSString *latString = [[NSNumber numberWithDouble: location.coordinate.latitude] stringValue];
    NSString *lonString =[[NSNumber numberWithDouble: location.coordinate.longitude] stringValue];
    
    NSURLComponents *components = [NSURLComponents componentsWithString: baseURL];
    
    NSURLQueryItem *lat = [NSURLQueryItem queryItemWithName:@"lat" value: latString];
    NSURLQueryItem *lon = [NSURLQueryItem queryItemWithName:@"lon" value: lonString];
    NSURLQueryItem *unitFormat = [NSURLQueryItem queryItemWithName:@"units" value: isCelciusEnable ? @"metric" : @"imperial"];
    
    NSURLQueryItem *appid = [NSURLQueryItem queryItemWithName:@"appid" value: @"edee7c3774cea803358c17ed3bf36159"];
    components.queryItems = @[lat,lon,unitFormat,appid];
    
    NSURL *url = components.URL;

    //Create session
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"URL session error: %@", error);
            completion(nil,error);
            return;
        }
        
        if(!data){
            NSLog(@"No data return from URL Session.");
            return;
        }
        
        //Parsing data
        NSError *parsingError;
        NSDictionary *weatherJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
        
        //Handle errors
        if(parsingError){
            NSLog(@"Error while parsing: %@", parsingError);
            completion(nil,parsingError);
            return;
        };
        
        // NSLog(@"temp: %@",weatherJSON[@"main"][@"temp"]);
        
        //Create new FGTWeatherForcast object
        FGTWeatherForcast *weather = [[FGTWeatherForcast alloc] initWithDictionary:weatherJSON];
        
        if(weather){
            completion(weather,nil);
            return;
        }
       
    }]resume];
}


@end

