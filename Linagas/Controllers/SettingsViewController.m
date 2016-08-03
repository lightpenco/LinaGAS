//
//  SettingsViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "MenuItems_model.h"
#import "Map_model.h"

@interface SettingsViewController ()<SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (strong, nonatomic) SWRevealViewController *revealVC;

@property (strong, nonatomic) NSArray *list;

@property (strong, nonatomic) Map_model *map_model;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MenuItems_model *menuItems_model = [[MenuItems_model alloc] init];
    
    self.map_model = [[Map_model alloc] init];
    
    self.list = [menuItems_model getSettingsItems];
    [self.tableView reloadData];
    [self prepareSWRevealView];
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareUI
{
    self.pageTitle.text = NSLocalizedString(@"Settings", @"Settings");
}

#pragma mark - Preparations

- (void)prepareSWRevealView
{
    self.revealVC = self.revealViewController;
    if (_revealVC)
    {
        _revealVC.rearViewRevealWidth = 250.0;
        _revealVC.rearViewRevealOverdraw = 0.0;
        _revealVC.delegate = self;
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
}

#pragma mark - SWRevealViewControllerDelegate

- (void)revealController:(SWRevealViewController *)revealController panGestureMovedToLocation:(CGFloat)location progress:(CGFloat)progress overProgress:(CGFloat)overProgress
{
    _overlay.alpha = progress;
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _overlay.alpha = position == FrontViewPositionLeft ? 0.0 : 1.0;
    }];
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell_settings";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    MenuItem *itemData = [_list objectAtIndex:indexPath.row];
    UILabel *item = (UILabel *)[cell viewWithTag:101];
    
    item.text = itemData.name;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    MenuItem *itemData = _list[indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [Common UIColorFromHex:0x1465FF];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        cell.backgroundColor = [Common UIColorFromHex:0xFFFFFF];
    });
    
    if ([itemData.name isEqualToString:NSLocalizedString(@"Language", @"Language")])
    {
        //Change Language
    }
    else if ([itemData.name isEqualToString:NSLocalizedString(@"Delete Locations", @"Delete Locations")])
    {
        //Delete Locations
        Address *address = [[Address alloc] init];
        address.line1 = @"";
        address.city = @"";
        address.postalCode = @"";
        address.country = @"JOR";
        
        LastLocation *location = [[LastLocation alloc] init];
        location.updatedDateTime = [NSDate date];
        location.location = CLLocationCoordinate2DMake(0, 0);
        __weak typeof(self) weakSelf = self;
        
        [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
        
        __block NSMutableArray *processed = [NSMutableArray array];
        __block BOOL failed;
        
        [_map_model setHomeAddress:address success:^(id response) {
            [processed addObject:@YES];
            if (processed.count == 2)
            {
                [weakSelf showAlertSuccess:NSLocalizedString(@"Delete Locations", @"Delete Locations") body:NSLocalizedString(@"Locations deleted!", @"Locations deleted!") closeButton:NSLocalizedString(@"OK", @"OK")];
            }
        } failure:^(ErrorApiResponse *response) {
            if (!failed)
            {
                failed = YES;
                [weakSelf showAlertError:NSLocalizedString(@"Delete Locations", @"Delete Locations") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
            }
        }];

        [_map_model setHomeLocation:location success:^(id response) {
            [processed addObject:@YES];
            if (processed.count == 2)
            {
                [weakSelf showAlertSuccess:NSLocalizedString(@"Delete Locations", @"Delete Locations") body:NSLocalizedString(@"Locations deleted!", @"Locations deleted!") closeButton:NSLocalizedString(@"OK", @"OK")];
            }
        } failure:^(ErrorApiResponse *response) {
            if (!failed)
            {
                failed = YES;
                [weakSelf showAlertError:NSLocalizedString(@"Delete Locations", @"Delete Locations") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
            }
        }];
        
    }
}

@end