//
//  Login_model.h
//  Linagas
//
//  Created by Huxley Alcain on 7/25/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Login_model : BaseObject

// API REQUESTS
- (void)loginWithUsername:(NSString *)username password:(NSString *)password success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)signupWithUsername:(NSString *)username password:(NSString *)password mobileNumber:(NSString *)mobileNumber success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)logoutUserWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)refereshSessionWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)requestVerificationPinWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)postVerificationPin:(NSString *)pin WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)requestPasswordReset:(NSString *)username email:(NSString *)email WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)postChangePassword:(NSString *)username email:(NSString *)email pin:(NSString *)pin newPassword:(NSString *)newPassword WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;

//DATA Manipulation
- (void)clearSessionInfo;
- (void)saveUserInfo:(NSDictionary *)userData;
- (BOOL)checkIfSessionValid;

@end
