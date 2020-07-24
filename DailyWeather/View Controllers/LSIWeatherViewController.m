//
//  LSIWeatherViewController.m


#import <CoreLocation/CoreLocation.h>
#import "LSIWeatherViewController.h"
#import "LSIWeatherIcons.h"
#import "LSIErrors.h"
#import "LSILog.h"
#import "FGTWeatherForcast.h"
#import "LSIWeatherIcons.h"
#import "FGTHourlyCollectionViewCell.h"
#import "FGTHourlyForecast.h"
#import "FGTFetchWeatherData.h"
#import "FGTDailyForecast.h"


#pragma mark - interface

@interface LSIWeatherViewController () {
    BOOL _requestedLocation;
}

@property (strong, nonatomic) IBOutlet UIImageView *iconLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *weatherConditionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;


@property (strong, nonatomic) IBOutlet UILabel *humidityLabel;
@property (strong, nonatomic) IBOutlet UILabel *feelsLikeLabel;
@property (strong, nonatomic) IBOutlet UILabel *lowTempLabel;
@property (strong, nonatomic) IBOutlet UILabel *precipitationProbLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (strong, nonatomic) IBOutlet UILabel *sunsetLabel;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
                                                         

@property CLLocationManager *locationManager;
@property CLLocation *location;
@property (nonatomic) CLPlacemark *placemark;
@property (nonatomic) bool isCelciusEnable;
@property FGTWeatherForcast *forcast;

@end

@interface LSIWeatherViewController (CLLocationManagerDelegate) <CLLocationManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>


@end

#pragma mark - implementation

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
   
    [FGTFetchWeatherData requestWeather:location isCelciusEnable:self.isCelciusEnable completion:^(FGTWeatherForcast * _Nonnull data, NSError * _Nonnull error) {
        if (error){
            NSLog(@"Error Fetching: %@", error);
            return;
        }
        
        if(data){
            //If exist pass it to the forcast to be use
            self.forcast = data;
            [self updateViews];
        }
        
    }];
}

- (void)updateViews {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.placemark) {
            self.locationLabel.text = self.placemark.administrativeArea;
        }
        
        
        if(self.forcast){
            
            FGTDailyForecast *daily = self.forcast.daily.firstObject;
            //Setup Labels
            self.weatherConditionsLabel.text = self.forcast.conditions;
            self.temperatureLabel.text = self.forcast.temperature;
            self.feelsLikeLabel.text = self.forcast.feelsLike;
            self.humidityLabel.text = self.forcast.humidity;
           
            self.sunriseLabel.text = self.forcast.sunrise;
            self.sunsetLabel.text = self.forcast.sunset;
            self.iconLabel.image = [UIImage imageNamed: self.forcast.icon];

            if([self.forcast.icon containsString:@"d"]){
                self.bgImageView.image = [UIImage imageNamed:@"day"];
            }else{
                self.bgImageView.image = [UIImage imageNamed:@"night"];
            }
            
            if(daily){
                self.lowTempLabel.text = [NSString stringWithFormat:@"%@°/%@°",daily.min, daily.max];
            }
        }
            
        [self.collectionView reloadData];
    });
    
}


#pragma mark -Actions

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
}


@end


# pragma mark - CLLocationManagerDelegate Methods

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



#pragma mark - CollectionView Methods

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    FGTHourlyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HourlyForecastCell" forIndexPath:indexPath];
    
    FGTHourlyForecast *data = self.forcast.hourly[indexPath.row];
    
    if (data) {
        if(indexPath.row == 0){
            cell.time.text = @"Now";
        }else{
            cell.time.text = data.dt;
        }
        
        cell.temperature.text = data.temp;

        
        cell.image.image = [UIImage imageNamed: data.icon];
    }
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 24;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end



