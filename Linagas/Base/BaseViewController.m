//
//  BaseViewController.m
//  Linagas
//
//  Created by Huxley on 23/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController()

@property (strong, nonatomic) MBProgressHUD *loader;

@property (strong, nonatomic) SCLAlertView *alertLoading;
@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addScreenTapGesture];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

- (void)addBlurEffectOnView:(UIView *)view withBlurStyle:(UIBlurEffectStyle)style
{
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:style];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    visualEffectView.frame = view.bounds;
    [view insertSubview:visualEffectView atIndex:0];
}

- (void)addScreenTapGesture
{
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    viewTap.numberOfTapsRequired = 1;
    viewTap.numberOfTouchesRequired = 1;
    viewTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewTap];
}

- (void)handleTapGesture:(UIGestureRecognizer *)sender
{
    [Common hideKeyboard];
}

- (void)showLoader:(BOOL)show inView:(UIView *)toView
{
    if (show)
    {
        self.loader = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _loader.mode = MBProgressHUDModeIndeterminate;
        _loader.label.text= @"Loading";
        _loader.contentColor = [Common UIColorFromHex:0x01A982];
        [Common hideKeyboard];
        [self.view setUserInteractionEnabled:NO];
    }
    else
    {
        [_loader hideAnimated:!show];
        [self.view setUserInteractionEnabled:YES];
    }
}

- (void)showAlertError:(NSString *)alertTitle body:(NSString *)body closeButton:(NSString *)closeButton
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:300.0f];
    
    [self hideAlertLoading];
    [alert showError:alertTitle subTitle:body closeButtonTitle:closeButton duration:0.0f]; // Error
}

- (void)showAlertSuccess:(NSString *)alertTitle body:(NSString *)body closeButton:(NSString *)closeButton
{
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:300.0f];
    
    [self hideAlertLoading];
    [alert showSuccess:alertTitle subTitle:body closeButtonTitle:closeButton duration:0.0f];
}

- (void)showAlertLoading:(NSString *)alertTitle body:(NSString *)body
{
    self.alertLoading = [[SCLAlertView alloc] initWithNewWindowWidth:300.0f];
    [_alertLoading showWaiting:alertTitle subTitle:body closeButtonTitle:nil duration:CGFLOAT_MAX];
}

- (void)hideAlertLoading
{
    [_alertLoading hideView];
    self.alertLoading = nil;
}

//// Alternative alert types
//
//[alert showNotice:@"Hello Notice" subTitle:@"This is a more descriptive notice text." closeButtonTitle:@"Done" duration:0.0f]; // Notice
//[alert showWarning:@"Hello Warning" subTitle:@"This is a more descriptive warning text." closeButtonTitle:@"Done" duration:0.0f]; // Warning
//[alert showInfo:@"Hello Info" subTitle:@"This is a more descriptive info text." closeButtonTitle:@"Done" duration:0.0f]; // Info
//[alert showEdit:@"Hello Edit" subTitle:@"This is a more descriptive info text with a edit textbox" closeButtonTitle:@"Done" duration:0.0f]; // Edit
//[alert showCustom:[UIImage imageNamed:@"git"] color:color title:@"Custom" subTitle:@"Add a custom icon and color for your own type of alert!" closeButtonTitle:@"OK" duration:0.0f]; // Custom
//[alert showWaiting:@"Waiting..." subTitle:@"Blah de blah de blah, blah. Blah de blah de" closeButtonTitle:nil duration:5.0f];
//[alert showQuestion:@"Question?" subTitle:kSubtitle closeButtonTitle:@"Dismiss" duration:0.0f];
//
//// Using custom alert width
//SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindowWidth:300.0f];

@end
