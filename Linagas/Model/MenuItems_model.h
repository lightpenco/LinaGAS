//
//  MenuItems_model.h
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "MenuItem.h"

@interface MenuItems_model : BaseObject

- (NSArray *)getMenuItems;
- (NSArray *)getProfileItems;
- (NSArray *)getSettingsItems;
- (NSArray *)getAboutItems;
- (NSString *)generateTermsAndConditions;
- (NSString *)generatePrivacyPolicy;

- (NSArray *)getAddressEntry;

@end
