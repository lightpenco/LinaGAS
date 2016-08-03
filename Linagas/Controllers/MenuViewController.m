//
//  MenuViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItems_model.h"

@interface MenuViewController()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *menuItems;
@property (strong, nonatomic) MenuItems_model *menuItems_model;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menuItems_model = [[MenuItems_model alloc] init];
    
    self.menuItems = [_menuItems_model getMenuItems];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell_menuItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIImageView *item = (UIImageView *)[cell viewWithTag:101];
    UILabel *label = (UILabel *)[cell viewWithTag:102];
    MenuItem *itemData = [_menuItems objectAtIndex:indexPath.row];
    
    [item setImage:[UIImage imageNamed:itemData.iconName]];
    label.text = itemData.name;
    
    cell.backgroundColor = [Common UIColorFromHex:0xFFFFFF alpha:1.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [Common UIColorFromHex:0x1465FF alpha:0.9];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItem *itemData = [_menuItems objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [Common UIColorFromHex:0x1465FF];
    
    [Common sendNotificationMessage:kToggleMenu withObject:@{@"selectorName" : itemData.selectorName}];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(400 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}


@end
