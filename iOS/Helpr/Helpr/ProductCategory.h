//
//  Category.h
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductCategory : NSObject

- (ProductCategory*) initFromJson:(NSDictionary*) jsonCategory;

@property (strong, nonatomic) NSArray* products;
@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* categoryDescription;

@property (nonatomic) NSInteger beaconId;

@end
