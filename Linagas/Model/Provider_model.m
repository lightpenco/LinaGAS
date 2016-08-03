//
//  Provider_model.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Provider_model.h"
#import "ApiConnector.h"

@interface Provider_model()

@property (strong, nonatomic) ApiConnector *apiConnector;

@end

@implementation Provider_model

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.apiConnector = [[ApiConnector alloc] init];
    }
    
    return self;
}

- (void)getProvider:(NSString *)providerId WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector getServiceProvider:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                              ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                           providerId:providerId
                              success:^(id response) {
                                  success([Provider getObjetFromApiResponse:response]);
                              } failure:^(ErrorApiResponse *response) {
                                  failure(response);
                              }];
}

@end