//
//  ApiDefinitions.h
//  Linagas
//
//  Created by Huxley on 23/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#ifndef ApiDefinitions_h
#define ApiDefinitions_h

#if DISTRIBUTION == 1
    #if DEBUG == 1
        #define baseUrl @"http://api001.eastus.cloudapp.azure.com:8080/linagasapi"
    #else
        #define baseUrl @"https://api-prod.linagas.com/linagasapi"
    #endif
#else
    #if DEBUG == 1
        #define baseUrl @"http://api001.eastus.cloudapp.azure.com:8080/linagasapi"
    #else
        #define baseUrl @"https://api-prod.linagas.com/linagasapi"
    #endif
#endif

#define LoginUrl baseUrl @"/session"
#define SignupUrl baseUrl @"/consumer"
#define UserProfileUrl baseUrl @"/consumer/%@"
#define ContactOfCustomerUrl baseUrl @"/consumer/%@/contact"
#define NameOfCustomerUrl baseUrl @"/consumer/%@/name"
#define LocationOfCustomerUrl baseUrl @"/consumer/%@/location"
#define AddressOfCustomerUrl baseUrl @"/consumer/%@/address"
#define OrdersOfCustomerUrl baseUrl @"/consumer/%@/orders"
#define ChangeUserPasswordUrl baseUrl @"/user/%@/password"
#define ServiceProvidersUrl baseUrl @"/serviceproviders?countries=%@"
#define ServiceProviderUrl baseUrl @"/serviceprovider/%@"

#define OrderUrl baseUrl @"/order"
#define OrderDetailsUrl baseUrl @"/order/%@"
#define OrderItemUrl baseUrl @"/order/%@/orderitem"
#define OrderStatusUrl baseUrl @"/order/%@/status"
#define OrderDeliveryUrl baseUrl @"/order/%@/delivery"

#define DeliveryStatusUrl baseUrl @"/delivery/%@/status"
#define DeliveryReviewUrl baseUrl @"/delivery/%@/customerreview"

#define RequestVerificationPinUrl baseUrl @"/session/%@/verificationpin"
#define VerificationPinUrl baseUrl @"/session/%@/verificationpin/%@"

#define PasswordResetRequestUrl baseUrl @"/password/reset"
#define PasswordResetUrl baseUrl @"/password/match"

#endif /* ApiDefinitions_h */
