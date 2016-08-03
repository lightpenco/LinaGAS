//
//  ServiceArea.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "ServiceArea.h"

@implementation ServiceArea

+ (ServiceArea *)getObjetFromApiResponse:(NSDictionary *)data
{
    ServiceArea *serviceArea = [[ServiceArea alloc] init];
    
    serviceArea.countries = data[@"countries"];
    serviceArea.states = data[@"states"];
    serviceArea.cities = data[@"cities"];
    serviceArea.postalCodes = data[@"postalCodes"];
    
    return serviceArea;
}

@end
