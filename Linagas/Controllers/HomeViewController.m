//
//  HomeViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/25/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "Map_model.h"
#import "MenuItems_model.h"
#import "JVFloatLabeledTextField.h"
#import "KeyboardNotifier.h"
#import "Orders_model.h"
#import "Provider_model.h"
#import "LGMapCallout.h"
#import "HCSStarRatingView.h"
#import "Login_model.h"

@import CoreLocation;

@import GoogleMaps;

@interface HomeViewController ()<SWRevealViewControllerDelegate, KeyboardDelegate, UITextFieldDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *overlay;
@property (weak, nonatomic) IBOutlet UILabel *pageTitle;

@property (weak, nonatomic) IBOutlet UIView *mapViewContainer;
@property (weak, nonatomic) IBOutlet UIView *historyViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *historyButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentTabLeading;

@property (weak, nonatomic) IBOutlet UIView *mapOverlay;

@property (weak, nonatomic) IBOutlet UIButton *orderButton;
@property (weak, nonatomic) IBOutlet UIButton *saveAddressButton;
@property (weak, nonatomic) IBOutlet UIButton *saveHomeLocationButton;

//Address entry
@property (weak, nonatomic) IBOutlet UIView *addressEntryView;
@property (weak, nonatomic) IBOutlet UITableView *addressEntryTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressEntryBottom;

//order entrty
@property (weak, nonatomic) IBOutlet UIView *orderEntryView;
@property (weak, nonatomic) IBOutlet UILabel *orderEntryCurrentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderEntryHomeLocationLabel;
@property (weak, nonatomic) IBOutlet UISwitch *orderEntryCurrentLocationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *orderEntryHomeLocationSwitch;
@property (weak, nonatomic) IBOutlet UITextField *orderEntryNumberOfTanksTextField;
@property (weak, nonatomic) IBOutlet UIStepper *orderEntryStepper;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderEntryBottom;


//Order Allocation Window
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderAllocationBottom;
@property (weak, nonatomic) IBOutlet UIButton *orderAllocationAction;
@property (weak, nonatomic) IBOutlet UIView *orderAllocationWaiting;
@property (weak, nonatomic) IBOutlet UIView *orderAllocationScheduled;
@property (weak, nonatomic) IBOutlet UILabel *orderAllocationWaitingLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderAllocationScheduledTruck;
@property (weak, nonatomic) IBOutlet UILabel *orderAllocationScheduledCompany;
@property (weak, nonatomic) IBOutlet UILabel *orderAllocationScheduledTime;
@property (weak, nonatomic) IBOutlet UILabel *orderAllocationScheduledTanks;

@property (strong, nonatomic) SWRevealViewController *revealVC;
@property (strong, nonatomic) KeyboardNotifier *keyboardNotifier;

@property (strong, nonatomic) NSMutableArray *currentProviderList;
@property (strong, nonatomic) NSArray *providerList;

@property (strong, nonatomic) NSArray *addressEntryList;
//Order History
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;
@property (weak, nonatomic) IBOutlet UIView *historyPlaceholderView;
@property (weak, nonatomic) IBOutlet UILabel *historyPlaceholderTitle;
@property (weak, nonatomic) IBOutlet UILabel *historyPlaceholderSubTitle;

@property (strong, nonatomic) NSArray *historyList;

//Customer Review
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *customerReviewBottom;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *customerReviewRating;
@property (weak, nonatomic) IBOutlet UITextView *customerReviewTextView;

//Verification pin
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verificationPinBottom;
@property (weak, nonatomic) IBOutlet UITextField *verificationPinTextField;
@property (weak, nonatomic) IBOutlet UILabel *verificationPinLabel;


@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) Login_model *login_model;
@property (strong, nonatomic) MenuItems_model *menuItems_model;
@property (strong, nonatomic) Map_model *map_model;
@property (strong, nonatomic) Orders_model *orders_model;
@property (strong, nonatomic) Provider_model *provider_model;
@property (strong, nonatomic) LastLocation *currentLocation;
@property (strong, nonatomic) Address *currentAddress;
@property (strong, nonatomic) Order *order;
@property (strong, nonatomic) Order *currentOrder;
@property (strong, nonatomic) OrderItem *currentOrderItem;
@property (strong, nonatomic) Provider *currentProvider;

@property (readwrite, nonatomic) BOOL firstLocationUpdate;
@property (readwrite, nonatomic) BOOL orderDelivered;
@property (readwrite, nonatomic) BOOL orderCancelled;

@property (strong, nonatomic) NSString *deliveryId;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }

    [self.locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [self prepareSWRevealView];
    [self prepareUI];
    [self prepareObservers];
    [self onMap:nil];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:12.879721
                                                            longitude:121.774017
                                                                 zoom:12];
    [self.mapView  animateToCameraPosition:camera];
    _mapView.settings.myLocationButton = YES;
    _mapView.settings.compassButton = YES;
    _mapView.delegate = self;
    // Listen to the myLocation property of GMSMapView.
    [_mapView addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
    
    // Ask for My Location data after the map has already been added to the UI.
    dispatch_async(dispatch_get_main_queue(), ^{
        _mapView.myLocationEnabled = YES;
    });
    
    self.mapView = _mapView;
    
    self.currentProviderList = [NSMutableArray array];
    
    self.map_model = [[Map_model alloc] init];
    self.orders_model = [[Orders_model alloc] init];
    self.provider_model = [[Provider_model alloc] init];
    self.login_model = [[Login_model alloc] init];
    
    self.keyboardNotifier = [[KeyboardNotifier alloc] initWithDelegate:self];
    
    self.currentAddress = [[Address alloc] init];
    _currentAddress.country = @"JOR";
    self.menuItems_model = [[MenuItems_model alloc] init];
    self.addressEntryList = [_menuItems_model getAddressEntry];
    [self.addressEntryTableView reloadData];
    [self performSelectorInBackground:@selector(getProviders) withObject:nil];
}

- (void)dealloc {
    [_mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    _currentLocation = [[LastLocation alloc] init];
    _currentLocation.location = location.coordinate;
    _currentLocation.updatedDateTime = location.timestamp;
    
    if (!_firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        _firstLocationUpdate = YES;
        
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}

- (void)prepareUI
{
    self.pageTitle.text = NSLocalizedString(@"Home", @"Home");
}

#pragma mark - Preparations

- (void)prepareObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuToggle:) name:kToggleMenu object:nil];
}

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

#pragma mark - Observer Methods

- (void)onMenuToggle:(NSNotification *)sender
{
    [self.revealVC revealToggleAnimated:YES];
    [Common hideKeyboard];
}

#pragma mark - UITableView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableView Delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows;
    
    if (tableView == _addressEntryTableView)
    {
        rows = _addressEntryList.count;
    }
    else if (tableView == _historyTableView)
    {
        rows = _historyList.count;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier;
    
    if (tableView == _addressEntryTableView)
    {
        cellIdentifier = @"cell_address";
    }
    else if (tableView == _historyTableView)
    {
        cellIdentifier = @"cell_history";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (tableView == _addressEntryTableView)
    {
        JVFloatLabeledTextField *item = (JVFloatLabeledTextField *)[cell viewWithTag:101];
        MenuItem *itemData = [_addressEntryList objectAtIndex:indexPath.row];
        
        item.placeholder = itemData.name;
        item.secureTextEntry = NO;
        item.delegate = self;
        if ([itemData.name isEqualToString:NSLocalizedString(@"House # / Unit # / Building / Street", @"House # / Unit # / Building / Street")])
        {
            item.keyboardType = UIKeyboardTypeAlphabet;
            item.text = _currentAddress.line1;
        }
        else if ([itemData.name isEqualToString:NSLocalizedString(@"City", @"City")])
        {
            item.keyboardType = UIKeyboardTypeAlphabet;
            item.text = _currentAddress.city;
        }
        else if ([itemData.name isEqualToString:NSLocalizedString(@"Postal Code", @"Postal Code")])
        {
            item.keyboardType = UIKeyboardTypeNumberPad;
            item.text = _currentAddress.postalCode;
        }
    }
    else if (tableView == _historyTableView)
    {
        NSDictionary *data = _historyList[indexPath.row];
        
        UILabel *truck = (UILabel *)[cell viewWithTag:101];
        UILabel *company = (UILabel *)[cell viewWithTag:102];
        UILabel *time = (UILabel *)[cell viewWithTag:103];
        UILabel *tank = (UILabel *)[cell viewWithTag:104];
        
        truck.text = [NSString stringWithFormat:NSLocalizedString(@"Truck: %@", @"Truck: %@"), data[@"truck"]];
        company.text = [NSString stringWithFormat:NSLocalizedString(@"Company name: %@", @"Company name: %@"), data[@"company"]];
        time.text = [NSString stringWithFormat:NSLocalizedString(@"Time: %@", @"Time: %@"), data[@"time"]];
        tank.text = [NSString stringWithFormat:NSLocalizedString(@"Tanks: %@", @"Tanks: %@"), data[@"tanks"]];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    
    if (tableView == _addressEntryTableView)
    {
        height = 50.0;
    }
    else if (tableView == _historyTableView)
    {
        height = 100.0;
    }
    
    return height;
}

#pragma mark - GMSMapViewDelegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    LGMapCallout *view =  [[[NSBundle mainBundle] loadNibNamed:@"LGMapCallout" owner:self options:nil] objectAtIndex:0];
    Provider *provider = marker.userData;
    
    view.layer.cornerRadius = 5.0;
    view.clipsToBounds = YES;
    view.company.text = provider.name.businessName;
    view.truck.text = provider.contact.name;
    view.provider = provider;
    
    return view;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    Provider *provider = marker.userData;
    
    NSString *phoneCallNum = [NSString stringWithFormat:@"tel://%@",provider.contact.phone];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneCallNum]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneCallNum]];
    }
}

#pragma mark - UIControls

- (IBAction)onMap:(id)sender
{
    _mapView.hidden = NO;
    _historyViewContainer.hidden = YES;
    [_historyButton setTitleColor:[Common UIColorFromHex:0x0525B1] forState:UIControlStateNormal];
    self.currentTabLeading.constant = 0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onHistory:(id)sender
{
    [self refreshHistoryList];
    _mapView.hidden = YES;
    _historyViewContainer.hidden = NO;
    self.currentTabLeading.constant = _mapButton.frame.size.width;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onOrderTank:(id)sender
{
    [self resetOrderEntry];
    _orderEntryBottom.constant = 0.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)onSaveHomeLocation:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    [_map_model setHomeLocation:_currentLocation success:^(id response) {
        [weakSelf showAlertSuccess:NSLocalizedString(@"Home Location", @"Home Location") body:NSLocalizedString(@"Location saved!", @"Location saved!") closeButton:NSLocalizedString(@"OK", @"OK")];
    } failure:^(ErrorApiResponse *response) {
        [weakSelf showAlertError:NSLocalizedString(@"Home Location", @"Home Location") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
    }];
}

- (IBAction)onSaveHomeAddress:(id)sender
{
    _addressEntryBottom.constant = 0.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - API Requests Methods

- (void)getProviders
{
    if ([SSKeychain passwordForService:kSessionID account:kApplicationID] && !_currentProvider)
    {
        [_map_model getProvidersWithSuccess:^(id response) {
            self.providerList = response;
            [self performSelectorInBackground:@selector(plotProvidersOnTheMap) withObject:nil];
            [self performSelectorInBackground:@selector(getProviders) withObject:nil];
        } failure:^(ErrorApiResponse *response) {
            [self performSelectorInBackground:@selector(getProviders) withObject:nil];
        }];
    }
}

- (void)plotProvidersOnTheMap
{
    self.providerList = [_providerList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"status.state == %d", PROVIDER_DISABLED]];
    
    if (_currentProvider)
    {
        if (!_currentProvider.marker)
        {
            [_mapView clear];
            GMSMarker *marker = [GMSMarker markerWithPosition:_currentProvider.lastLocation.location];
            marker.icon = _currentProvider ? [UIImage imageNamed:@"ico_truckblue"] : [UIImage imageNamed:@"ico_truckorange"];
            marker.map = _mapView;
            _currentProvider.marker = marker;
        }
        else
        {
            _currentProvider.marker.position = _currentProvider.lastLocation.location;
        }
    }
    else
    {
        if (_currentProviderList.count == 0)
        {
            [_mapView clear];
        }
        
        [_providerList enumerateObjectsUsingBlock:^(Provider  *provider, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (provider)
            {
                NSArray *listTemp = [_currentProviderList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"providerId == %@", provider.providerId]];
                if (listTemp.count)
                {
                    Provider *providertemp = listTemp[0];
                    [_currentProviderList removeObject:providertemp];
                    providertemp.marker.position = provider.lastLocation.location;
                    [_currentProviderList addObject:providertemp];
                }
                else
                {
                    GMSMarker *marker = [GMSMarker markerWithPosition:provider.lastLocation.location];
                    marker.icon = !_currentProvider ? [UIImage imageNamed:@"ico_truckblue"] : [UIImage imageNamed:@"ico_truckorange"];
                    marker.map = _mapView;
                    marker.infoWindowAnchor = CGPointMake(0.5, 0.2);
                    marker.userData = provider;
                    provider.marker = marker;
                    
                    [_currentProviderList addObject:provider];
                }
            }
        }];
    }
}

#pragma mark - KeyboardNotifier Delegate

- (void)keyboardWillHide:(NSDictionary *)info
{
    [self adjustUIWithKeyboard:NO offset:0];
}

- (void)keyboardWillShow:(NSDictionary *)info
{
    NSValue* keyboardFrameBegin = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    [self adjustUIWithKeyboard:[keyboardFrameBegin CGRectValue].size.height > 0 offset:[keyboardFrameBegin CGRectValue].size.height];
}

- (void)adjustUIWithKeyboard:(BOOL)withKeyboard offset:(CGFloat)offset
{
    [self.view needsUpdateConstraints];
    [UIView animateWithDuration:kAnimationDurationWithKeyboard animations:^{
        
        if (_addressEntryBottom.constant >= 0)
        {
            _addressEntryBottom.constant = withKeyboard ? _addressEntryBottom.constant + offset : offset;
        }
        else if (_customerReviewBottom.constant >= 0)
        {
            _customerReviewBottom.constant = withKeyboard ? _customerReviewBottom.constant + offset : offset;
        }
        else if (_verificationPinBottom.constant >= 0)
        {
            _verificationPinBottom.constant = withKeyboard ? _verificationPinBottom.constant + offset : offset;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    CGPoint center= textField.center;
    CGPoint rootViewPoint = [textField.superview convertPoint:center toView:self.addressEntryTableView];
    NSIndexPath *indexPath = [self.addressEntryTableView indexPathForRowAtPoint:rootViewPoint];
    
    NSString *processedText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    MenuItem *item = _addressEntryList[indexPath.row];
    
    if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"House # / Unit # / Building / Street", @"House # / Unit # / Building / Street")])
    {
        self.currentAddress.line1 = processedText;
    }
    else if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"City", @"City")])
    {
        self.currentAddress.city = processedText;
    }
    else if ([textField.placeholder isEqualToString:item.name] && [item.name isEqualToString:NSLocalizedString(@"Postal Code", @"Postal Code")])
    {
        self.currentAddress.postalCode = processedText;
    }
    
    return YES;
}

#pragma mark - Orders

- (IBAction)gasTankStepperValueChanged:(UIStepper *)sender {
    double value = [sender value];
    
    [_orderEntryNumberOfTanksTextField setText:[NSString stringWithFormat:@"%d", (int)value]];
}

- (IBAction)orderEntryHomeLocationValueChanged:(UISwitch *)sender {
    
    [_orderEntryCurrentLocationSwitch setOn:NO];
    
}

- (IBAction)orderEntryCurrentLocationValueChanged:(UISwitch *)sender {
    [_orderEntryHomeLocationSwitch setOn:NO];
}

- (IBAction)processOrderTank:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    [_orders_model postOrder:_order quantity:[_orderEntryNumberOfTanksTextField.text integerValue] WithSuccess:^(id response) {
        self.currentOrder = response[@"order"];
        self.currentOrderItem = response[@"orderItem"];
        self.orderCancelled = NO;
        
        [weakSelf hideAlertLoading];
        [weakSelf resetOrderEntry];
        [weakSelf updateAllocationWaiting];
        [weakSelf performSelectorInBackground:@selector(fetchOrderDetails) withObject:nil];
        [weakSelf performSelectorInBackground:@selector(fetchOrderDeliveryDetails) withObject:nil];
    } failure:^(ErrorApiResponse *response) {
        if ([response.code isEqualToString:ERR_SYSTEM_USER_NOT_VERIFIED])
        {
            [_login_model requestVerificationPinWithSuccess:^(id response) {
                
            } failure:^(ErrorApiResponse *response) {
                
            }];
        }
        
        if (response)
        {
            [weakSelf resetOrderEntry];
            [weakSelf openVerificationPin];
        }
        [weakSelf showAlertError:NSLocalizedString(@"Order", @"Order") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
    }];
}

- (IBAction)cancelOrderTank:(id)sender
{
    [self resetOrderEntry];
}

- (void)resetOrderEntry
{
    self.order = [[Order alloc] init];
    _order.orderType = 0;
    _order.orderProcessingType = 1;
    _order.consumerId = [SSKeychain passwordForService:kOwnerID account:kApplicationID];
    _order.userId = [SSKeychain passwordForService:kUserID account:kApplicationID];;
    _order.totalCost = 0;
    _order.totalTax = 0;
    _order.costCurrency = @"JOD";
    _order.itemsType = 1;
    
    _orderEntryStepper.value = 1;
    _orderEntryBottom.constant = -178.0;
    
    _orderButton.hidden = _saveAddressButton.hidden = _saveHomeLocationButton.hidden = NO;
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 0.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)resetOrders
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.orderDelivered = NO;
        self.currentOrder = nil;
        self.currentOrderItem = nil;
        self.currentProvider = nil;
        self.deliveryId = nil;
        self.currentProviderList = [NSMutableArray array];
        [self performSelectorInBackground:@selector(getProviders) withObject:nil];
    });
}

#pragma mark - Address

- (IBAction)saveHomeAddress:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    [_map_model setHomeAddress:_currentAddress success:^(id response) {
        [weakSelf resetAddressEntry];
        [weakSelf showAlertSuccess:NSLocalizedString(@"Home Location", @"Home Location") body:NSLocalizedString(@"Location saved!", @"Location saved!") closeButton:NSLocalizedString(@"OK", @"OK")];
    } failure:^(ErrorApiResponse *response) {
        [weakSelf resetAddressEntry];
        [weakSelf showAlertError:NSLocalizedString(@"Home Location", @"Home Location") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
    }];
}

- (IBAction)cancelHomeAddress:(id)sender
{
    [self resetAddressEntry];
}

- (void)resetAddressEntry
{
    self.currentAddress = [[Address alloc] init];
    _currentAddress.country = @"JOR";
    _currentAddress.line1 = @"";
    _currentAddress.city = @"";
    _currentAddress.postalCode = @"";
    
    _addressEntryBottom.constant = -206.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 0.0;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Order Allocation

- (void)fetchOrderDetails
{
    if ([SSKeychain passwordForService:kSessionID account:kApplicationID] && (!_orderCancelled && !_orderDelivered))
    {
        __weak typeof(self) weakSelf = self;
        [_orders_model getOrder:_currentOrder.orderId WithSuccess:^(id response) {
            self.currentOrder = response;
            [weakSelf performSelectorInBackground:@selector(fetchOrderDetails) withObject:nil];
        } failure:^(ErrorApiResponse *response) {
            [weakSelf performSelectorInBackground:@selector(fetchOrderDetails) withObject:nil];
        }];
    }
    else
    {
        self.currentOrder = nil;
    }
}

- (void)fetchOrderDeliveryDetails
{
    if ([SSKeychain passwordForService:kSessionID account:kApplicationID] && (!_orderCancelled && !_orderDelivered))
    {
        __weak typeof(self) weakSelf = self;
        [_orders_model getOrderDelivery:_currentOrder.orderId WithSuccess:^(id response) {
            if ([response count] && _currentProvider)
            {
                self.deliveryId = response[0][@"id"];
                [weakSelf updateAllocationSchedule];
            }
            else if ([response count] && !_currentProvider)
            {
                [weakSelf fetchProvider:response[0][@"serviceProviderId"]];
            }
            
            if ([response count] && [response[0][@"status"][@"state"] integerValue] == ORDER_STATUS_ALLOCATED)
            {
                [weakSelf updateAllocationScheduleComplete];
            }
            [weakSelf performSelectorInBackground:@selector(fetchOrderDeliveryDetails) withObject:nil];
        } failure:^(ErrorApiResponse *response) {
            [weakSelf performSelectorInBackground:@selector(fetchOrderDeliveryDetails) withObject:nil];
        }];
    }
}

- (void)fetchProvider:(NSString *)providerId
{
    if ([SSKeychain passwordForService:kSessionID account:kApplicationID] && providerId && (!_orderCancelled && !_orderDelivered))
    {
        __weak typeof(self) weakSelf = self;
        [_provider_model getProvider:providerId WithSuccess:^(id response) {
            self.currentProvider = response;
            [weakSelf performSelectorInBackground:@selector(plotProvidersOnTheMap) withObject:nil];
            [weakSelf performSelectorInBackground:@selector(fetchProvider:) withObject:_currentProvider.providerId];
        } failure:^(ErrorApiResponse *response) {
            [weakSelf performSelectorInBackground:@selector(fetchProvider:) withObject:_currentProvider.providerId];
        }];
    }
    else
    {
        self.currentProvider = nil;
    }
}

- (IBAction)onOrderAllocationAction:(id)sender
{
    if (_orderDelivered)
    {
        [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
        [_orders_model postDeliveryStatus:_deliveryId state:ORDER_STATUS_COMPLETE success:^(id response) {
            [self hideAlertLoading];
            [self openCustomerReview];
            _orderAllocationBottom.constant = -84.0;
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [self.view layoutIfNeeded];
            }];
        } failure:^(ErrorApiResponse *response) {
            [self hideAlertLoading];
        }];
    }
    else
    {
        #warning add confirmation
        [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
        [_orders_model postOrderStatus:_currentOrder state:ORDER_STATUS_CANCELLED success:^(id response) {
            self.orderCancelled = YES;
            [self hideAlertLoading];
            [self resetOrders];
            [self resetOrderEntry];
            _orderAllocationBottom.constant = -84.0;
            [UIView animateWithDuration:kAnimationDuration animations:^{
                [self.view layoutIfNeeded];
            }];
        } failure:^(ErrorApiResponse *response) {
            [self hideAlertLoading];
        }];
    }
}

- (void)updateAllocationWaiting
{
    [_orderAllocationAction setImage:[UIImage imageNamed:@"ico_no"] forState:UIControlStateNormal];
 
    _orderButton.hidden = _saveAddressButton.hidden = _saveHomeLocationButton.hidden = YES;
    
    _orderAllocationBottom.constant = 0.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    _orderAllocationScheduled.hidden = YES;
    _orderAllocationWaiting.hidden = NO;
    _orderAllocationWaitingLabel.hidden = !_orderAllocationScheduled.hidden;
    _orderAllocationWaitingLabel.text = NSLocalizedString(@"Order in progress...", @"Order in progress...");
}

- (void)updateAllocationSchedule
{
    [self saveOrderDetails];
    _orderAllocationScheduled.hidden = NO;
    _orderAllocationWaiting.hidden = YES;
    _orderAllocationWaitingLabel.hidden = !_orderAllocationScheduled.hidden;
    _orderAllocationScheduledTruck.text = [NSString stringWithFormat:NSLocalizedString(@"Truck: %@", @"Truck: %@"), _currentProvider.contact.name];
    _orderAllocationScheduledCompany.text = [NSString stringWithFormat:NSLocalizedString(@"Company name: %@", @"Company name: %@"), _currentProvider.name.businessName];
    _orderAllocationScheduledTime.text = [NSString stringWithFormat:NSLocalizedString(@"Time: %@", @"Time: %@"), [_currentOrder dateStringFromDate:_currentOrder.creationDateTime]];
    _orderAllocationScheduledTanks.text = [NSString stringWithFormat:NSLocalizedString(@"Tanks: %@", @"Tanks: %@"), [NSString stringWithFormat:@"%zd", _currentOrderItem.quantity]];
}

- (void)updateAllocationScheduleComplete
{
    self.orderDelivered = YES;
    [_orderAllocationAction setImage:[UIImage imageNamed:@"ico_yes"] forState:UIControlStateNormal];
}

- (void)saveOrderDetails
{
    NSMutableArray *orderHistory = [Common objectInDataCacheForKey:kOrderHistory] ? [NSMutableArray arrayWithArray:[Common objectInDataCacheForKey:kOrderHistory]] : [NSMutableArray array];
    
    if (![orderHistory count] || ([orderHistory count] && ![[orderHistory filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"orderId == %@", _currentOrder.orderId]] count]))
    {
        if (_currentOrder && _currentProvider && _currentOrderItem)
        {
            NSDictionary *data = @{@"orderId" : _currentOrder.orderId,
                                   @"truck" : _currentProvider.contact.name,
                                   @"company" : _currentProvider.name.businessName,
                                   @"time" : [_currentOrder dateStringFromDate:_currentOrder.creationDateTime],
                                   @"tanks" : [NSString stringWithFormat:@"%zd", _currentOrderItem.quantity]};
            [orderHistory addObject:data];
            [Common setObject:orderHistory inDataCacheForKey:kOrderHistory];
        }
    }
}


#pragma mark - History

- (IBAction)onDeleteHistory:(id)sender
{
#warning add confirmation
    [Common removeObjectFromDataCacheForKey:kOrderHistory];
    [self refreshHistoryList];
}

- (void)refreshHistoryList
{
    self.historyList = [Common objectInDataCacheForKey:kOrderHistory];
    if ([_historyList count])
    {
        _historyPlaceholderView.hidden = YES;
        [self.historyTableView reloadData];
    }
    else
    {
        _historyPlaceholderView.hidden = NO;
        _historyPlaceholderTitle.text = NSLocalizedString(@"Order History is Empty", @"Order History is Empty");
        _historyPlaceholderSubTitle.text = NSLocalizedString(@"All orders made will be displayed here. Please go to Home tab to place an order.", @"All orders made will be displayed here. Please go to Home tab to place an order.");
    }
}

#pragma mark - Customer Review

- (IBAction)onSubmitReview:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    
    CustomerReview *review = [[CustomerReview alloc] init];
    review.rating = _customerReviewRating.value;
    review.feedback = @[@{@"message" : _customerReviewTextView.text}];
    
    [_orders_model postDeliveryReview:_deliveryId rating:review success:^(id response) {
        [weakSelf showAlertSuccess:NSLocalizedString(@"Orders complete!", @"Orders complete!") body:NSLocalizedString(@"Rating sent.\n Thank you for using Linagas.", @"Thank you for using Linagas.") closeButton:NSLocalizedString(@"OK", @"OK")];
        [self resetOrders];
        [self resetOrderEntry];
        [self resetCustomerReview];
    } failure:^(ErrorApiResponse *response) {
        [weakSelf showAlertError:NSLocalizedString(@"Orders", @"Orders") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
    }];
}

- (void)openCustomerReview
{
    _customerReviewTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _customerReviewTextView.layer.borderWidth = 1.0;
    
    _customerReviewBottom.constant = 0.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)resetCustomerReview
{
    _customerReviewRating.value = 0;
    _customerReviewTextView.text = @"";
    _customerReviewBottom.constant = -268.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 0.0;
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Verification Pin

- (IBAction)onSubmitPin:(id)sender
{
    if ([_verificationPinTextField.text length])
    {
        __weak typeof(self) weakSelf = self;
        
        [_login_model postVerificationPin:_verificationPinTextField.text WithSuccess:^(id response) {
            [weakSelf showAlertSuccess:NSLocalizedString(@"User Validation", @"User Validation") body:NSLocalizedString(@"User validated!", @"User validated!") closeButton:NSLocalizedString(@"OK", @"OK")];
            [weakSelf resetVerficationPin];
        } failure:^(ErrorApiResponse *response) {
            [weakSelf showAlertError:NSLocalizedString(@"User Validation", @"User Validation") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
        }];
    }
    else
    {
        [self showAlertError:NSLocalizedString(@"Error", @"Error") body:NSLocalizedString(@"Please enter pin.", @"Please enter pin.") closeButton:NSLocalizedString(@"OK", @"OK")];
    }
}

- (void)openVerificationPin
{
    _verificationPinTextField.text = @"";
    _verificationPinBottom.constant = 0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 1.0;
        [self.view layoutIfNeeded];
    }];
}

- (void)resetVerficationPin
{
    _verificationPinTextField.text = @"";
    _verificationPinBottom.constant = -148.0;
    [UIView animateWithDuration:kAnimationDuration animations:^{
        _mapOverlay.alpha = 0.0;
        [self.view layoutIfNeeded];
    }];
}

@end
