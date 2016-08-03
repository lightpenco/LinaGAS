//
//  BaseTabBarController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/27/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseTabBarController.h"
#import "BaseViewController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareObservers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changeTab:(TabBarOptions)option
{
    [self setSelectedIndex:option];
}

- (void)prepareObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuToggle:) name:kToggleMenu object:nil];
}

#pragma mark - Observer Methods

- (void)onMenuToggle:(NSNotification *)sender
{
    if (sender.userInfo)
    {
        [self performSelector:NSSelectorFromString(sender.userInfo[@"selectorName"])];
    }
}

#pragma mark - Controls

- (void)onHomeToggle
{
    [self changeTab:TabBarOptions_Home];
}

- (void)onProfileToggle
{
    [self changeTab:TabBarOptions_Profile];
}

- (void)onSettingsToggle
{
    [self changeTab:TabBarOptions_Settings];
}

- (void)onShareToggle
{
    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

- (void)onAboutToggle
{
    [self changeTab:TabBarOptions_About];
}

- (void)onLogoutToggle
{
    [Common sendNotificationMessage:kLogout withObject:nil];
}

@end
