//
//  Profile_model.h
//  Linagas
//
//  Created by Huxley Alcain on 7/27/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "ApiModelObjects.h"

@interface Profile_model : BaseObject

//API REQUESTS
- (void)updateProfile:(Name *)name contact:(Contact *)contact oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getUserProfileWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getUserContactWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;


@end
