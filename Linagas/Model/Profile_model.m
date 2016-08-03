//
//  Profile_model.m
//  Linagas
//
//  Created by Huxley Alcain on 7/27/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Profile_model.h"
#import "ApiConnector.h"

@interface Profile_model()

@property (strong, nonatomic) ApiConnector *apiConnector;

@end

@implementation Profile_model

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.apiConnector = [[ApiConnector alloc] init];
    }
    
    return self;
}

- (void)updateProfile:(Name *)name contact:(Contact *)contact oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    __block NSMutableDictionary *retVal = [NSMutableDictionary dictionary];
    __block BOOL failed;
    __block NSUInteger expectedNumberOfData = (oldPassword && newPassword) ? 3 : 2;
    
    [_apiConnector updateNameForConsumer:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                 ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                               firstName:name.firstName
                                lastName:name.lastName
                              middleName:name.middleName
                              salutation:name.salutation
                            businessName:name.businessName
                                 success:^(id response) {
                                     [retVal setObject:[Name getObjetFromApiResponse:response] forKey:@"name"];
                                     if (retVal.count == expectedNumberOfData)
                                     {
                                         success(retVal);
                                     }
                                 } failure:^(ErrorApiResponse *response) {
                                     if (!failed)
                                     {
                                         failed = true;
                                         failure(response);
                                     }
                                 }];
    [_apiConnector updateContactForConsumer:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                    ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                       name:contact.name
                                description:contact.desc
                                        fax:contact.fax
                                      phone:contact.phone
                                      email:contact.email
                                    success:^(id response) {
                                        [retVal setObject:[Contact getObjetFromApiResponse:response] forKey:@"contact"];
                                        if (retVal.count == expectedNumberOfData)
                                        {
                                            success(retVal);
                                        }
                                    } failure:^(ErrorApiResponse *response) {
                                        if (!failed)
                                        {
                                            failed = true;
                                            failure(response);
                                        }
                                    }];
    if (oldPassword && newPassword)
    {
        [_apiConnector updateUserPassword:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                  ownerId:[SSKeychain passwordForService:kUserID account:kApplicationID]
                              oldPassword:oldPassword
                              newPassword:newPassword
                                  success:^(id response) {
                                      if (retVal.count == expectedNumberOfData)
                                      {
                                          success(retVal);
                                      }
                                  } failure:^(ErrorApiResponse *response) {
                                      if (!failed)
                                      {
                                          failed = true;
                                          failure(response);
                                      }
                                  }];
    }
}

- (void)getUserProfileWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector getNameForConsumer:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                              ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                              success:^(NSDictionary *response) {
                                  success([Name getObjetFromApiResponse:response]);
                              } failure:^(ErrorApiResponse *response) {
                                  failure(response);
                              }];
}

- (void)getUserContactWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector getContactForConsumer:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                 ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                 success:^(id response) {
                                     success([Contact getObjetFromApiResponse:response]);
                                 } failure:^(ErrorApiResponse *response) {
                                     failure(response);
                                 }];
}

@end
