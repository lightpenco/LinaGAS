//
//  ProfileViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "ProfileViewController.h"
#import "SWRevealViewController.h"
#import "MenuItems_model.h"
#import "JVFloatLabeledTextField.h"
#import "Profile_model.h"

@interface ProfileViewController ()<SWRevealViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;

@property (strong, nonatomic) SWRevealViewController *revealVC;
@property (strong, nonatomic) Profile_model *profile_model;
@property (strong, nonatomic) Name *name;
@property (strong, nonatomic) Contact *contact;

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSString *password;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.profile_model = [[Profile_model alloc] init];
    
    MenuItems_model *menuItems_model = [[MenuItems_model alloc] init];
    self.list = [menuItems_model getProfileItems];
    
    [self prepareSWRevealView];
    [self prepareUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    
    [_profile_model getUserProfileWithSuccess:^(id response) {
        self.name = response;
        [weakSelf hideAlertLoading];
        [self.tableView reloadData];
    } failure:^(ErrorApiResponse *response) {
        [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
    }];
    [_profile_model getUserContactWithSuccess:^(id response) {
        [weakSelf hideAlertLoading];
        self.contact = response;
        [self.tableView reloadData];
    } failure:^(ErrorApiResponse *response) {
        [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareUI
{
    self.pageTitle.text = NSLocalizedString(@"Profile", @"Profile");
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

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    CGPoint center= textField.center;
    CGPoint rootViewPoint = [textField.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    
    NSString *processedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    MenuItem *item = _list[indexPath.row];
    if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"First name", @"First name")])
    {
        self.name.firstName = processedText;
    }
    else if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"Last name", @"Last name")])
    {
        self.name.lastName = processedText;
    }
    else if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"Email", @"Email")])
    {
        self.contact.email = processedText;
    }
    else if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"Password", @"Password")])
    {
        self.password = processedText;
    }
    else if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"Phone", @"Phone")])
    {
        self.contact.phone = processedText;
    }
    return YES;
}

#pragma mark - UIControls

- (IBAction)onSave:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Saving...", @"Saving...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    
    [_profile_model updateProfile:_name
                          contact:_contact
                      oldPassword:[SSKeychain passwordForService:kUserPassword account:kApplicationID]
                      newPassword:_password
                          success:^(id response) {
                              [weakSelf showAlertSuccess:NSLocalizedString(@"Profile update", @"Profile update") body:NSLocalizedString(@"Profile saved!", @"Profile saved!") closeButton:NSLocalizedString(@"OK", @"OK")];
                              self.name = response[@"name"];
                              self.contact = response[@"contact"];
                              self.password = nil;
                              [self.tableView reloadData];
                          } failure:^(ErrorApiResponse *response) {
                              [weakSelf showAlertError:NSLocalizedString(@"Profile update", @"Profile update") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
                          }];
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
    static NSString *cellIdentifier = @"cell_profile";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    JVFloatLabeledTextField *item = (JVFloatLabeledTextField *)[cell viewWithTag:101];
    MenuItem *itemData = [_list objectAtIndex:indexPath.row];
    
    item.placeholder = itemData.name;
    item.secureTextEntry = NO;
    if ([itemData.name isEqualToString:NSLocalizedString(@"First name", @"First name")])
    {
        item.keyboardType = UIKeyboardTypeAlphabet;
        item.text = _name.firstName;
    }
    else if ([itemData.name isEqualToString:NSLocalizedString(@"Last name", @"Last name")])
    {
        item.keyboardType = UIKeyboardTypeAlphabet;
        item.text = _name.lastName;
    }
    else if ([itemData.name isEqualToString:NSLocalizedString(@"Email", @"Email")])
    {
        item.keyboardType = UIKeyboardTypeEmailAddress;
        item.text = _contact.email;
    }
    else if ([itemData.name isEqualToString:NSLocalizedString(@"Password", @"Password")])
    {
        item.keyboardType = UIKeyboardTypeAlphabet;
        item.secureTextEntry = YES;
        item.text = _password ? _password : @"defaultpassword";
    }
    else if ([itemData.name isEqualToString:NSLocalizedString(@"Phone", @"Phone")])
    {
        item.keyboardType = UIKeyboardTypePhonePad;
        item.text = _contact.phone;
    }
    
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

@end
