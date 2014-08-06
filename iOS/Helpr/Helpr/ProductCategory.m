//
//  Category.m
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import "ProductCategory.h"
#import "Product.h"

@implementation ProductCategory
{
}

- (ProductCategory*) initFromJson:(NSDictionary*)jsonCategory
{
    self.title = jsonCategory[@"title"];
    self.categoryDescription = jsonCategory[@"description"];
    self.beaconId = [jsonCategory[@"beacon_id"] integerValue];

    NSArray* jsonProducts = jsonCategory[@"products"];
    NSMutableArray* prods = [[NSMutableArray alloc]initWithCapacity:20];
    
    for (NSDictionary* jsonProduct in jsonProducts) {
        Product* product = [[Product alloc]initFromJson:jsonProduct];
        [prods addObject:product];
    }
    
    self.products = prods;
    
    return self;
}
@end
