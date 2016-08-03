//
//  Map_model.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Map_model.h"
#import "ApiConnector.h"

@interface Map_model()

@property (strong, nonatomic) ApiConnector *apiConnector;

@end

@implementation Map_model

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.apiConnector = [[ApiConnector alloc] init];
    }
    
    return self;
}

- (void)getProvidersWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector getServiceProviders:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                               ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                               country:@"JOR"
                               success:^(id response) {
                                   NSMutableArray *providers = [NSMutableArray array];
                                   
                                   for (NSDictionary *data in response)
                                   {
                                       [providers addObject:[Provider getObjetFromApiResponse:data]];
                                   }
                                   success(providers);
                               } failure:^(ErrorApiResponse *response) {
                                   failure(response);
                               }];
}

- (void)setHomeLocation:(LastLocation *)location success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector updateConsumerLocation:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                  ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                 dateTime:[self dateStringFromDate:location.updatedDateTime]
                                      lat:location.location.latitude
                                      lon:location.location.longitude
                                  success:^(id response) {
                                      success(response);
                                  } failure:^(ErrorApiResponse *response) {
                                      failure(response);
                                  }];
}

- (void)setHomeAddress:(Address *)address success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector updateAddress:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                         ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                           line1:address.line1
                            city:address.city
                      postalCode:address.postalCode
                         country:address.country
                         success:^(id response) {
                             success(response);
                         } failure:^(ErrorApiResponse *response) {
                             failure(response);
                         }];
}

@end

