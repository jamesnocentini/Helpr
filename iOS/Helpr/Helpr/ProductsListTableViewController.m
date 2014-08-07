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

@interface NSArray (myTransformingAddition)
-(NSArray*)transformWithBlock:(id(^)(id))block;
@end

@implementation NSArray (myTransformingAddition)
-(NSArray*)transformWithBlock:(id(^)(id))block{
    NSMutableArray*result=[NSMutableArray array];
    for(id x in self){
        if (x)
            [result addObject:block(x)];
    }
    return result;
}
@end

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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(filterTableView)];
    // To make the navigation bar black
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions xy:(CGPoint)point size:(CGSize)size isMultiple:(BOOL)isMultiple{
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions xy:point size:size isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    [Dropobj SetBackGroundDropDwon_R:0.0 G:108.0 B:194.0 alpha:0.70];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectedIndex:(NSInteger)anIndex {
}

- (void)DropDownListView:(DropDownListView *)dropdownListView Datalist:(NSMutableArray*)data {
}

- (void)DropDownListViewDidCancel{
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isKindOfClass:[UIView class]]) {
        [Dropobj fadeOut];
    }
}

- (void)filterTableView {

    NSArray* categoryNames = [_categories transformWithBlock:^id(id o) {
        return ((ProductCategory*)o).title;
    }];

    
    [Dropobj fadeOut];
    [self showPopUpWithTitle:@"Select Categories" withOption:categoryNames xy:CGPointMake(16, 58) size:CGSizeMake(287, 330) isMultiple:YES];

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ProductCategory* category = _categories[section];

    return category.title;
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
