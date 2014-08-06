//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "RangingManager.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

NSString* RangingManager_DidRangeBeacons = @"RangingManager_DidRangeBeacons";

@implementation RangingManager
{
@private
    CLLocationManager* locationManager;
    CLBeaconRegion *beaconRegion;
    CBCentralManager *centralManager;
}

+ (RangingManager *) defaultInstance
{
    static RangingManager *_instance = nil;

    @synchronized (self)
    {
        if (_instance == nil)
        {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

- (void)startForUuid:(NSString *)uuid
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];


    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Beacon monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }

    NSUUID *nsUuid = [[NSUUID alloc] initWithUUIDString:uuid];

    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nsUuid identifier:@"BlueBar Beacon Region"];
    beaconRegion.notifyEntryStateOnDisplay = YES;
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;

    // Tell location manager to start monitoring for the beacon region
    [locationManager startMonitoringForRegion:beaconRegion];
    [locationManager startRangingBeaconsInRegion:beaconRegion];

}

- (void)locationManager:(CLLocationManager*)manager didEnterRegion:(CLRegion *)region
{
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    NSLog(@"Enterred region: %@\n", region.identifier);
}

-(void)locationManager:(CLLocationManager*)manager didExitRegion:(CLRegion *)region
{
    // Exited the region
    NSLog(@"Exited region: %@\n", region.identifier);
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RangingManager_DidRangeBeacons object:beacons];
}


- (void)stop
{
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
    [locationManager stopMonitoringForRegion:beaconRegion];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static CBCentralManagerState previousState = -1;

    switch ([centralManager state])
    {
        case CBCentralManagerStatePoweredOff:
        {
            /* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            if (previousState != -1)
            {
                NSString *title = @"Bluetooth is Off";
                NSString *message = @"Please enable Bluetooth to receive micro-location updates. Helpr uses iBeacon technology which relies on Bluetooth LE and is very power efficient.";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }

        case CBCentralManagerStateUnauthorized:
        {
            /* Tell user the app is not allowed. */
            break;
        }

        case CBCentralManagerStateUnknown:
        {
            /* Bad news, let's wait for another event. */
            break;
        }

        case CBCentralManagerStatePoweredOn:
        {
            break;
        }

        case CBCentralManagerStateResetting:
        {
            break;
        }
    }

    previousState = [centralManager state];
}
@end