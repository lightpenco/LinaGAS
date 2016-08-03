//
//  LastLocation.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "LastLocation.h"

@implementation LastLocation

+ (LastLocation *)getObjetFromApiResponse:(NSDictionary *)data
{
    LastLocation *lastLocation = [[LastLocation alloc] init];
    
    if (![data[@"updatedDateTime"] isKindOfClass:[NSNull class]])
    {
        lastLocation.updatedDateTime = [lastLocation dateFromApiResponse:data[@"updatedDateTime"]];
    }
    
    lastLocation.location = CLLocationCoordinate2DMake([data[@"latitude"] floatValue], [data[@"longitude"] floatValue]);
    
    return lastLocation;
}

@end
