//
//  Provider.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Provider.h"

@interface Provider()

@end

@implementation Provider

+ (Provider *)getObjetFromApiResponse:(NSDictionary *)data
{
    Provider *provider = [[Provider alloc] init];
    
    provider.providerId = [data[@"id"] isKindOfClass:[NSNull class]] ? @"" : data[@"id"];
    provider.creationDate = [data[@"creationDate"] isKindOfClass:[NSNull class]] ? nil : [provider dateFromApiResponse:data[@"creationDate"]];;
    provider.lastLocation = [data[@"lastLocation"] isKindOfClass:[NSNull class]] ? nil : [LastLocation getObjetFromApiResponse:data[@"lastLocation"]];
    provider.contact = [data[@"contact"] isKindOfClass:[NSNull class]] ? nil : [Contact getObjetFromApiResponse:data[@"contact"]];
    provider.name = [data[@"contact"] isKindOfClass:[NSNull class]] ? nil : [Name getObjetFromApiResponse:data[@"name"]];
    provider.serviceOrganizationId = [data[@"serviceOrganizationId"] isKindOfClass:[NSNull class]] ? @"" : data[@"serviceOrganizationId"];
    provider.templateIds = [data[@"templateIds"] isKindOfClass:[NSNull class]] ? nil : data[@"templateIds"];
    provider.ratingSummary = [data[@"ratingSummary"] isKindOfClass:[NSNull class]] ? nil : [RatingSummary getObjetFromApiResponse:data[@"ratingSummary"]];
    provider.status = [data[@"status"] isKindOfClass:[NSNull class]] ? nil : [Status getObjetFromApiResponse:data[@"status"]];
    provider.serviceArea = [data[@"serviceArea"] isKindOfClass:[NSNull class]] ? nil : [ServiceArea getObjetFromApiResponse:data[@"serviceArea"]];
    
    return provider;
}

@end