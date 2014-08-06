//
//  ProductTableViewCell.m
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import "ProductTableViewCell.h"
#import "Product.h"

@implementation ProductTableViewCell
{
@private
    __weak Product *_product;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (Product *)product {
    return _product;
}

- (void)setProduct:(Product *)product {
    
    _product = product;
    if (_product)
    {
        self.Title.text = _product.title;
        
    }
}

@end
