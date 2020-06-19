//
//  LSIWeatherViewController.m
//
//  Created by Paul Solt on 2/6/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LSIWeatherViewController.h"
#import "LSIWeatherIcons.h"
#import "LSIErrors.h"
#import "LSILog.h"
#import "FGTWeatherForcast.h"
#import "LSIWeatherIcons.h"
#import "FGTHourlyCollectionViewCell.h"

@interface LSIWeatherViewController () {
    BOOL _requestedLocation;
}

@property (strong, nonatomic) IBOutlet UIImageView *iconLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherConditionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;


@property (strong, nonatomic) IBOutlet UILabel *windLabel;
@property (strong, nonatomic) IBOutlet UILabel *feelsLikeLabel;
@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *preassureLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunsetLabel;



@property CLLocationManager *locationManager;
@property CLLocation *location;
@property (nonatomic) CLPlacemark *placemark;
@property (nonatomic) bool isCelciusEnable;
@property FGTWeatherForcast *forcast;

@end

// NOTE: You must declare the Category before the main implementation,
// otherwise you'll see errors about the type not being correct if you
// try to move delegate methods out of the main implementation body
@interface LSIWeatherViewController (CLLocationManagerDelegate) <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@end


@implementation LSIWeatherViewController


- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    // TODO: Transparent toolbar with info button (Settings)
    // TODO: Handle settings button pressed
    NSUserDefaults *userDefaultsPref = [NSUserDefaults standardUserDefaults];
    bool isCelcius = [userDefaultsPref boolForKey:@"isCelciusEnable"];
    self.isCelciusEnable = isCelcius;
}


//https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names
- (void)requestCurrentPlacemarkForLocation:(CLLocation *)location
                            withCompletion:(void (^)(CLPlacemark *, NSError *))completionHandler {
    if (location) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
                
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if (error) {
                completionHandler(nil, error);
                return;
            }
            
            if (placemarks.count >= 1) {
                CLPlacemark *place = placemarks.firstObject;
                
                completionHandler(place, nil);
                return;
                
            } else {
                NSError *placeError = errorWithMessage(@"No places match current location", LSIPlaceError);
                
                completionHandler(nil, placeError);
                return;
            }
        }];
        
    } else {
        NSLog(@"ERROR: Missing location, please provide location");
    }
}

- (void)requestUserFriendlyLocation:(CLLocation *)location {
    if(!_requestedLocation) {
        _requestedLocation = YES;
        __block BOOL requestedLocation = _requestedLocation;
        
        [self requestCurrentPlacemarkForLocation:location withCompletion:^(CLPlacemark *place, NSError *error) {
            
            //NSLog(@"Location: %@, %@", place.locality, place.administrativeArea);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.location = location;
                self.placemark = place;
                [self updateViews];
            });
            requestedLocation = NO;
        }];
    }
}

- (void)requestWeatherForLocation:(CLLocation *)location {
    
    // TODO: 1. Parse CurrentWeather.json from App Bundle and update UI
    //Base URL: https://openweathermap.org/current
    NSString *baseURL = @"https://api.openweathermap.org/data/2.5/weather?";
    
    NSString *latString = [[NSNumber numberWithDouble: location.coordinate.latitude] stringValue];
    NSString *lonString =[[NSNumber numberWithDouble: location.coordinate.longitude] stringValue];
    
    NSURLComponents *components = [NSURLComponents componentsWithString: baseURL];
    
    NSURLQueryItem *lat = [NSURLQueryItem queryItemWithName:@"lat" value: latString];
    NSURLQueryItem *lon = [NSURLQueryItem queryItemWithName:@"lon" value: lonString];
    NSURLQueryItem *unitFormat = [NSURLQueryItem queryItemWithName:@"units" value: self.isCelciusEnable ? @"imperial" : @"metric"];
    NSURLQueryItem *appid = [NSURLQueryItem queryItemWithName:@"appid" value: @"edee7c3774cea803358c17ed3bf36159"];
    components.queryItems = @[lat,lon,unitFormat,appid];
    
    NSURL *url = components.URL;

    //Create session
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if(error){
            NSLog(@"URL session error: %@", error);
            return;
        }
        
        if(!data){
            NSLog(@"No data return from URL Session.");
            return;
        }
        
        //NSLog(@"Finished Fetching weather");
        
//        NSString *dummyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"Dummy data: %@",dummyData);
        
        
        //Parsing data
        NSError *parsingError;
        NSDictionary *weatherJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&parsingError];
        
        //Handle errors
        if(parsingError){
            NSLog(@"Error while parsing: %@", parsingError);
            return;
        };
        
        // NSLog(@"temp: %@",weatherJSON[@"main"][@"temp"]);
        
        //Create new FGTWeatherForcast object
        FGTWeatherForcast *weather = [[FGTWeatherForcast alloc] initWithDictionary:weatherJSON];
        
        if(weather){
            //If exist pass it to the forcast to be use
            self.forcast = weather;
        }
        
        [self updateViews];
       
    }]resume];
}

- (void)updateViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.placemark) {
            // TODO: Update the City, State label
            
            self.locationLabel.text = self.placemark.administrativeArea;
            
        }
        
        // TODO: Update the UI based on the current forecast
        if(self.forcast){
            //Setup Labels
             self.weatherConditionsLabel.text = self.forcast.conditions;
            self.temperatureLabel.text = self.forcast.temperature;
            self.windLabel.text = self.forcast.windSpeed;
            self.feelsLikeLabel.text = self.forcast.feelsLike;
            self.humidityLabel.text = self.forcast.humidity;
            self.preassureLabel.text = self.forcast.pressure;
            self.sunriseLabel.text = self.forcast.sunrise;
            self.sunsetLabel.text = self.forcast.sunset;
            
            
            //Setup icon
            UIImage *uiIcon = [LSIWeatherIcons weatherImageForIconName: self.forcast.iconID];
            
            self.iconLabel.image = uiIcon;
        }
    });
}


/// MARK:Actions
- (IBAction)toggleUnitsFormatButton:(UIBarButtonItem *)sender {

    //self.isCelciusEnable = !self.isCelciusEnable;
    NSUserDefaults *userDefaultsPref = [NSUserDefaults standardUserDefaults];
    
    if(self.isCelciusEnable){
        [userDefaultsPref setBool: false forKey:@"isCelciusEnable"];
        self.isCelciusEnable = false;
    }else{
        [userDefaultsPref setBool: true forKey:@"isCelciusEnable"];
        self.isCelciusEnable = true;
    }
    
    
    [userDefaultsPref synchronize];
    //Request data with repective units
    [self requestWeatherForLocation: self.location];
    
    //NSLog(@"Toggle: %d",self.isCelciusEnable);
}


@end

/// MARK: CLLocationManagerDelegate Methods

@implementation LSIWeatherViewController(CLLocationManagerDelegate)

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager Error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    NSLog(@"locationManager: found location %@", locations.firstObject);
    
    CLLocation *location = locations.firstObject;
    
    // 1. Request Weather for location
    
    [self requestWeatherForLocation: location];
    
    // 2. Request User-Friendly Place Names for Lat/Lon coordinate
    
    [self requestUserFriendlyLocation: location];
    
    // Stop updating location after getting one (NOTE: this is faster than doing a single location request)
    [manager stopUpdatingLocation];
}

/// MARK:CollectionView Methods
- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HourlyForecast" forIndexPath:indexPath];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}




@end



