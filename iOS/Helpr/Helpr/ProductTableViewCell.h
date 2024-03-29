//
//  ProductTableViewCell.h
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ProductTableViewCell : UITableViewCell

@property ( nonatomic, weak ) Product* product;

@property (strong, nonatomic) IBOutlet UIImageView *Image;
@property (strong, nonatomic) IBOutlet UILabel *Title;

@end
