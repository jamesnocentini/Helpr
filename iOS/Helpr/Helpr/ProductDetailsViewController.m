//
//  ProductDetailsViewController.m
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "Product.h"
#import "Helpr-Swift.h"

@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController
{
@private
    __weak Product *_product;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    
    [self updateProductDetails];
}

- (void)updateProductDetails {

    if (_product)
    {
        self.Title.text = _product.title;
        
        // Set the image
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[_product.imageName stringByDeletingPathExtension] ofType:[_product.imageName pathExtension]];
        
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        self.Image.image = image;
        
        // Set the description (not set yet)
//        self.Description.text = _product.description;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (Product *)product {
    return _product;
}


- (void)setProduct:(Product *)product {
    _product = product;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    VideoViewController* destination = [segue destinationViewController];
    [destination setProduct:_product];
}


@end
