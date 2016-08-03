//
//  MenuItems_model.m
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "MenuItems_model.h"

@interface MenuItems_model()

@property (strong, nonatomic) NSArray *items;

@end

@implementation MenuItems_model

- (NSArray *)getMenuItems
{
    NSMutableArray *data = [NSMutableArray array];
    
    [data addObjectsFromArray:@[@{@"name" : @"Home",
                                  @"iconName" : @"ico_home",
                                  @"selectorName" : @"onHomeToggle"},
                                @{@"name" : @"Profile",
                                  @"iconName" : @"ico_profile",
                                  @"selectorName" : @"onProfileToggle"},
                                @{@"name" : @"Settings",
                                  @"iconName" : @"ico_settings",
                                  @"selectorName" : @"onSettingsToggle"},
                                @{@"name" : @"Share",
                                  @"iconName" : @"ico_share",
                                  @"selectorName" : @"onShareToggle"},
                                @{@"name" : @"About",
                                  @"iconName" : @"ico_about",
                                  @"selectorName" : @"onAboutToggle"},
                                @{@"name" : @"Logout",
                                  @"iconName" : @"ico_logout",
                                  @"selectorName" : @"onLogoutToggle"}]];

    return [self generateObjectsFromData:data];
}

- (NSArray *)getProfileItems
{
    NSMutableArray *data = [NSMutableArray array];
    
    [data addObjectsFromArray:@[@{@"name" : NSLocalizedString(@"First name", @"First name")},
                                @{@"name" : NSLocalizedString(@"Last name", @"Last name")},
                                @{@"name" : NSLocalizedString(@"Email", @"Email")},
                                @{@"name" : NSLocalizedString(@"Password", @"Password")},
                                @{@"name" : NSLocalizedString(@"Phone", @"Phone")}]];
    
    return [self generateObjectsFromData:data];
}

- (NSArray *)getSettingsItems
{
    NSMutableArray *data = [NSMutableArray array];
    
    [data addObjectsFromArray:@[@{@"name" : NSLocalizedString(@"Language", @"Language")},
                                @{@"name" : NSLocalizedString(@"Delete Locations", @"Delete Locations")}]];
    
    return [self generateObjectsFromData:data];
}

- (NSArray *)getAboutItems
{
    NSMutableArray *data = [NSMutableArray array];
    
    [data addObjectsFromArray:@[@{@"name" : NSLocalizedString(@"About", @"About")},
                                @{@"name" : NSLocalizedString(@"License and Agreement", @"License and Agreement")},
                                @{@"name" : NSLocalizedString(@"Privacy Policy", @"Privacy Policy")}]];
    
    return [self generateObjectsFromData:data];
}

- (NSArray *)getAddressEntry
{
    NSMutableArray *data = [NSMutableArray array];
    
    [data addObjectsFromArray:@[@{@"name" : NSLocalizedString(@"House # / Unit # / Building / Street", @"House # / Unit # / Building / Street")},
                                @{@"name" : NSLocalizedString(@"City", @"City")},
                                @{@"name" : NSLocalizedString(@"Postal Code", @"Postal Code")}]];
    
    return [self generateObjectsFromData:data];
}

- (NSString *)generateTermsAndConditions
{
    return  [Common getContentsOfFile:@"TermsAndConditions" extension:@"txt"];
}

- (NSString *)generatePrivacyPolicy
{
    return  [Common getContentsOfFile:@"PrivacyPolicy" extension:@"txt"];
}

- (NSArray *)generateObjectsFromData:(NSArray *)listData
{
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *data in listData) {
        MenuItem *item = [[MenuItem alloc] init];
        
        item.name = data[@"name"] ? data[@"name"] : @"";
        item.iconName = data[@"iconName"] ? data[@"iconName"] : @"";
        item.selectorName = data[@"selectorName"] ? data[@"selectorName"] : @"";
        [list addObject:item];
    }
    return list;
}

@end