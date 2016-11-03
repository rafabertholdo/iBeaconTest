//
//  TrackerViewController.m
//  IbeaconTest
//
//  Created by Rafael Bertholdo on 7/24/14.
//  Copyright (c) 2014 Bertholdo. All rights reserved.
//

#import "TrackerViewController.h"

@interface TrackerViewController ()
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation TrackerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
}


-(void)initRegion
{
    NSUUID *guid = [[NSUUID alloc] initWithUUIDString:@"DC0A818A-C7D3-4608-B8FB-A3E62DC952A2"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:guid identifier:@"com.bertholdo.beacon"];
    [self.locationManager startMonitoringForRegion:self.beaconRegion];

}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
    }
    
    if (!([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        NSLog(@"Couldn't turn on monitoring: Location services not authorised.");
        

        
        [self.locationManager requestAlwaysAuthorization];
    }else{
        [self initRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion - error: %@", [error localizedDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    self.beaconFoundLabel.text = @"No";
}



-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if([beacons count])
    {
        CLBeacon *beacon = [beacons firstObject];
        
        self.beaconFoundLabel.text = @"Yes";
        self.proximityUUIDLabel.text = beacon.proximityUUID.UUIDString;
        self.majorLabel.text = [NSString stringWithFormat:@"%@", beacon.major];
        self.minorLabel.text = [NSString stringWithFormat:@"%@", beacon.minor];
        self.accuracyLabel.text = [NSString stringWithFormat:@"%f", beacon.accuracy];
        if (beacon.proximity == CLProximityUnknown) {
            self.distanceLabel.text = @"Unknown Proximity";
        } else if (beacon.proximity == CLProximityImmediate) {
            self.distanceLabel.text = @"Immediate";
        } else if (beacon.proximity == CLProximityNear) {
            self.distanceLabel.text = @"Near";
        } else if (beacon.proximity == CLProximityFar) {
            self.distanceLabel.text = @"Far";
        }
        self.rssiLabel.text = [NSString stringWithFormat:@"%i", beacon.rssi];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
