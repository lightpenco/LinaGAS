//
//  Status.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Status.h"

@implementation Status

+ (Status *)getObjetFromApiResponse:(NSDictionary *)data
{
    Status *status = [[Status alloc] init];
    
    if (![data[@"updatedDateTime"] isKindOfClass:[NSNull class]])
    {
        status.updateDateTime = [status dateFromApiResponse:data[@"updatedDateTime"]];
    }
    
    status.state = [data[@"state"] integerValue];
    
    return status;
}

@end
