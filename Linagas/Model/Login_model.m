//
//  Login_model.m
//  Linagas
//
//  Created by Huxley Alcain on 7/25/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Login_model.h"
#import "ApiConnector.h"

@interface Login_model()

@property (strong, nonatomic) ApiConnector *apiConnector;

@end

@implementation Login_model

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.apiConnector = [[ApiConnector alloc] init];
    }
    
    return self;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
{
    [_apiConnector createSession:username password:password success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)logoutUserWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector deleteSession:[SSKeychain passwordForService:kSessionID account:kApplicationID] success:^(NSDictionary *response) {
        [self clearSessionInfo];
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)signupWithUsername:(NSString *)username password:(NSString *)password mobileNumber:(NSString *)mobileNumber success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector createConsumer:username password:password phone:mobileNumber country:@"JOR" success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)refereshSessionWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector refreshSession:[SSKeychain passwordForService:kSessionID account:kApplicationID] success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)requestVerificationPinWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector requestVerificationPIN:[SSKeychain passwordForService:kSessionID account:kApplicationID] success:^(id response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)postVerificationPin:(NSString *)pin WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector validateVerificationPIN:[SSKeychain passwordForService:kSessionID account:kApplicationID] pin:pin success:^(id response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)requestPasswordReset:(NSString *)username email:(NSString *)email WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector changePassword:username
                            email:email
                          success:^(id response) {
                              success(response);
                          } failure:^(ErrorApiResponse *response) {
                              failure(response);
                          }];
}

- (void)postChangePassword:(NSString *)username email:(NSString *)email pin:(NSString *)pin newPassword:(NSString *)newPassword WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector requestPasswordReset:username
                                  email:email
                                    pin:pin
                            newPassword:newPassword
                                success:^(id response) {
                                    
                                } failure:^(ErrorApiResponse *response) {
                                    
                                }];
}

- (void)clearSessionInfo
{
    [SSKeychain deletePasswordForService:kSessionID account:kApplicationID];
    [SSKeychain deletePasswordForService:kSessionValidUntil account:kApplicationID];
    [SSKeychain deletePasswordForService:kUserID account:kApplicationID];
    [SSKeychain deletePasswordForService:kOwnerID account:kApplicationID];
}

- (void)saveUserInfo:(NSDictionary *)userData
{
    [SSKeychain setPassword:userData[@"id"] forService:kSessionID account:kApplicationID];
    [SSKeychain setPassword:userData[@"maxValidUntil"] forService:kSessionValidUntil account:kApplicationID];
    [SSKeychain setPassword:userData[@"userId"] forService:kUserID account:kApplicationID];
    [SSKeychain setPassword:userData[@"ownerInfo"][@"ownerId"] forService:kOwnerID account:kApplicationID];
    [SSKeychain setPassword:userData[@"password"] forService:kUserPassword account:kApplicationID];
}

- (BOOL)checkIfSessionValid
{
    NSString *dateString = [SSKeychain passwordForService:kSessionValidUntil account:kApplicationID];
    BOOL valid = NO;
    
    if (dateString)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate *dateValidUntil;
        NSDate *dateToday = [NSDate date];
        
        [dateFormatter setDateFormat:@"yyyy-mm-dd'T'HH:mm:ssZZZ"];
        dateValidUntil = [dateFormatter dateFromString:dateString];
        
        if ([dateValidUntil compare:dateToday] == NSOrderedAscending || [dateValidUntil compare:dateToday] == NSOrderedSame)
        {
            valid = YES;
        }
    }
    
    return valid;
}

@end
