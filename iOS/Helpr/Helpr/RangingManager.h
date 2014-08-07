//
// Created by Vladimir Petrov on 08/06/2014.
// Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString* RangingManager_DidRangeBeacons;

@interface RangingManager : NSObject < CLLocationManagerDelegate >

+ (RangingManager *) defaultInstance;

-(void) startForUuid:(NSString *)uuid;

- (void)stop;
@end