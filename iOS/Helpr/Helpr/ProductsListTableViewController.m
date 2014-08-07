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
#import "RangingManager.h"

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
    NSArray* _selectedCategoryIndexes;
    NSArray* _selectedCategories;

    NSMutableArray * _beaconIds;
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
    
    NSMutableArray* mutableSelectedIndex = [[NSMutableArray alloc]initWithCapacity:_categories.count];
    for (int n = 0; n < _categories.count; n++) {
        [mutableSelectedIndex addObject:[[NSNumber alloc]initWithInt:n]];
    }
    
    _selectedCategoryIndexes = mutableSelectedIndex;
    _selectedCategories = _categories;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _beaconIds = [[NSMutableArray alloc]init];
    
    [self loadProducts];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterCategories:) name:RangingManager_DidRangeBeacons object:nil];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(filterTableView)];
    // To make the navigation bar black
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

}

- (void) filterCategories:(NSNotification*)notificationObject{

    if (notificationObject == nil || notificationObject.object == nil)
        return;
    
    NSArray* beacons = notificationObject.object;
    
    
    NSMutableArray* newBeaconIds = [[NSMutableArray alloc]init];
    
    for (CLBeacon* beacon in beacons) {
        BOOL found = NO;
        for (NSNumber* existingId in _beaconIds) {
            if (beacon.minor.intValue == existingId.intValue)
            {
                found = YES;
                break;
            }
        }
        
        if (!found){
            for (int n=0; n < _categories.count; n++) {
                ProductCategory* cat = _categories[n];
                if (cat.beaconId == beacon.minor.integerValue)
                {
                    [newBeaconIds addObject:[[NSNumber alloc]initWithInt:beacon.minor.intValue]];
                }
            }
        }
    }
    
    if (newBeaconIds.count == 0)
        return;
    
    _beaconIds = newBeaconIds;
    
    NSMutableArray* selectedCategoriesMutable = [[NSMutableArray alloc]init];
    NSMutableArray* mutableSelectedIndex = [[NSMutableArray alloc]initWithCapacity:_categories.count];

        for (NSNumber* beaconId in newBeaconIds) {
            for (int n=0; n < _categories.count; n++) {
                ProductCategory* cat = _categories[n];
                if (cat.beaconId == beaconId.integerValue)
                {
                    [selectedCategoriesMutable addObject:cat];
                    [mutableSelectedIndex addObject:[[NSNumber alloc]initWithInt:n]];
                }
            }
        }
    
    if (selectedCategoriesMutable.count > 0)
    {
        _selectedCategories = selectedCategoriesMutable;
        _selectedCategoryIndexes = mutableSelectedIndex;
        [self.tableView reloadData];
    }
}

-(void)showPopUpWithTitle:(NSString*)popupTitle withOption:(NSArray*)arrOptions isMultiple:(BOOL)isMultiple{
    
    Dropobj = [[DropDownListView alloc] initWithTitle:popupTitle options:arrOptions selectedIndexes:_selectedCategoryIndexes xy:CGPointMake(16, 58) size:CGSizeMake(287, 330) isMultiple:isMultiple];
    Dropobj.delegate = self;
    [Dropobj showInView:self.view animated:YES];
    
    [Dropobj SetBackGroundDropDwon_R:0.0 G:108.0 B:194.0 alpha:0.70];
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectSingle:(NSInteger)itemIndex {
    
}

- (void)DropDownListView:(DropDownListView *)dropdownListView didSelectMultiple:(NSMutableArray*)data {
    _selectedCategoryIndexes = data;
    
    NSMutableArray* selectedCategoriesMutable = [[NSMutableArray alloc]init];
    
    for (NSNumber* index in _selectedCategoryIndexes) {
        [selectedCategoriesMutable addObject:_categories[index.integerValue]];
    }
    
    _selectedCategories = selectedCategoriesMutable;
    
    [self.tableView reloadData];
}

- (void)DropDownListViewDidCancel {
    
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
    [self showPopUpWithTitle:@"Select Categories" withOption:categoryNames isMultiple:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _selectedCategories.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    ProductCategory* category = _selectedCategories[section];
    
    return category.products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
    
    ProductCategory* category = _selectedCategories[indexPath.section];
    Product* product = category.products[indexPath.row];
    
    [cell setProduct:product];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    ProductCategory* category = _selectedCategories[section];

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

    ProductCategory* category = _selectedCategories[indexPath.section];
    Product* product = category.products[indexPath.row];
    
    [destination setProduct:product];

    
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
