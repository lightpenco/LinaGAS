//
//  AboutViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "MenuItems_model.h"
#import "GenericTextViewController.h"

@interface AboutViewController ()<SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) SWRevealViewController *revealVC;
@property (strong, nonatomic) NSArray *list;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareSWRevealView];
    [self prepareUI];
    
    MenuItems_model *menuItems_model = [[MenuItems_model alloc] init];
    self.list = [menuItems_model getAboutItems];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareUI
{
    self.pageTitle.text = NSLocalizedString(@"About", @"About");
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
    static NSString *cellIdentifier = @"cell_item";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:101];
    MenuItem *itemData = [_list objectAtIndex:indexPath.row];
    
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
    MenuItem *itemData = [_list objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [Common UIColorFromHex:0x1465FF];
    
    if ([itemData.name isEqualToString:NSLocalizedString(@"About", @"About")])
    {
        [self performSegueWithIdentifier:segue_aboutDetailsVC sender:nil];
    }
    else if ([itemData.name isEqualToString:NSLocalizedString(@"License and Agreement", @"License and Agreement")])
    {
        MenuItems_model *menuItems_model = [[MenuItems_model alloc] init];
        
        NSDictionary *data = @{@"title" : NSLocalizedString(@"Terms of use", @"Terms of use"),
                               @"body" : [menuItems_model generateTermsAndConditions]};
        
        [self performSegueWithIdentifier:segue_genericVC sender:data];
    }
    else
    {
        MenuItems_model *menuItems_model = [[MenuItems_model alloc] init];
        
        NSDictionary *data = @{@"title" : NSLocalizedString(@"Privacy Policy", @"Privacy Policy"),
                               @"body" : [menuItems_model generatePrivacyPolicy]};
        [self performSegueWithIdentifier:segue_genericVC sender:data];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(400 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Navigations

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:segue_genericVC])
    {
        GenericTextViewController *genericVC = (GenericTextViewController *)segue.destinationViewController;
        
        genericVC.titleName = sender[@"title"];
        genericVC.body = sender[@"body"];
    }
}

@end
