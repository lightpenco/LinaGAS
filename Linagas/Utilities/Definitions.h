//
//  Definitions.h
//  Linagas
//
//  Created by Huxley on 23/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#ifndef Definitions_h
#define Definitions_h

#pragma mark - Enumerations

typedef NS_ENUM(NSUInteger, TabBarOptions) {
    TabBarOptions_Home = 0,
    TabBarOptions_Profile = 1,
    TabBarOptions_Settings = 2,
    TabBarOptions_About = 3
};

typedef NS_ENUM(NSUInteger, PROVIDER_VALID_STATES) {
    PROVIDER_DISABLED,
    PROVIDER_ENABLED
};

typedef NS_ENUM(NSUInteger, ORDER_VALID_STATES) {
    ORDER_STATUS_INITIATED = 0,
    ORDER_STATUS_READY = 1,
    ORDER_STATUS_PAYMENT_RECEIVED = 20,
    ORDER_STATUS_ALLOCATING = 40,
    ORDER_STATUS_ALLOCATED = 60,
    ORDER_STATUS_DELIVERY_SCHEDULED = 80,
    ORDER_STATUS_DELIVERED = 100,
    ORDER_STATUS_COMPLETE = 120,
    ORDER_STATUS_CANCELLED = 140
};

#pragma mark - Definitions

#define kFirstTimeUse @"kFirstTimeUse"

#define ERR_SYSTEM_USER_NOT_VERIFIED @"ERR-SYSTEM-USER-NOT-VERIFIED"

//API keys
#define kParamUsername @"lgas.seed.username"
#define kParamPassword @"lgas.seed.pass"
#define kParamApplicationId @"lgas.applicationid"
#define kParamSessionId @"lgas.user.sessionid"

//Data Keys
#define kApplicationID @"com.linagas.linagas"
#define kSessionID @"kSessionID"
#define kSessionValidUntil @"kSessionValidUntil"
#define kUserID @"kUserID"
#define kOwnerID @"kOwnerID"
#define kUserPassword @"kUserPassword"
#define kOrderHistory @"kOrderHistory"

//App keys
#define kToggleMenu @"kToggleMenu"
#define kLogout @"kLogout"

#pragma mark - Google Maps API KEY

#define kGoogleMapsAPIKey_Consumer @"AIzaSyC7wMpcUonqAZSpDazUt9aRdt1boz2tQow"
#define kGoogleMapsAPIKey_Distributor @"AIzaSyDCdgaKUgGataaVw_fxbD-S5tdDLHu_MEs"

#pragma mark - SEGUE

#define segue_homeVC @"segue_homeVC"
#define segue_homeVCWithoutAnimation @"segue_homeVCWithoutAnimation"
#define segue_aboutDetailsVC @"segue_aboutDetailsVC"
#define segue_genericVC @"segue_genericVC"

#pragma mark - TAGS

#define kTagAlertView_Logout 1001

#endif /* Definitions_h */
