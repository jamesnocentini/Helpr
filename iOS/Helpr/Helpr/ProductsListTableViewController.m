//
//  ProductsListTableViewController.m
//  Helpr
//
//  Created by Vladimir Petrov on 06/08/2014.
//  Copyright (c) 2014 James Nocentini. All rights reserved.
//

#import "ProductsListTableViewController.h"
#import "ProductTableViewCell.h"
#import "Product.h"
#import "ProductCategory.h"
#import "ProductDetailsViewController.h"

@interface ProductsListTableViewController ()

@end

@implementation ProductsListTableViewController
{
    NSMutableArray * _categories;
}

+(NSDictionary*) fromJsonFile:(NSString*)fileLocation {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:[fileLocation stringByDeletingPathExtension] ofType:[fileLocation pathExtension]];
    NSData* data = [NSData dataWithContentsOfFile:filePath];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}

- (void)loadProducts{
    
    NSArray* jsonCategories = [ProductsListTableViewController fromJsonFile:@"products.json"];
    
    _categories = [[NSMutableArray alloc]initWithCapacity:20];
    
    for (NSDictionary* jsonCategory in jsonCategories) {
        ProductCategory* category = [[ProductCategory alloc]initFromJson: jsonCategory];
        [_categories addObject:category];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadProducts];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _categories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ProductCategory* category = _categories[section];
    
    return category.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    
    ProductCategory* category = _categories[indexPath.section];
    Product* product = category.products[indexPath.row];
    
    [cell setProduct:product];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ProductDetailsViewController* destination = [segue destinationViewController];
    
//    UITableViewCell* cell = (UITableViewCell*)sender;
//    NSIndexPath* path = [self.tableView indexPathForCell: cell];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    ProductCategory* category = _categories[indexPath.section];
    Product* product = category.products[indexPath.row];
    
    [destination setProduct:product];
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
