//
//  Product.m
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import "Product.h"

@implementation Product
{
    
}

- (Product*) initFromJson:(NSDictionary*)jsonProduct
{
    Product* product = [[Product alloc]init];
    
    product.title = jsonProduct[@"title"];
    product.imageName = jsonProduct[@"imageName"];
    
    return product;
}

@end
