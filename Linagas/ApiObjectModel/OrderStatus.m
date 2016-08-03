//
//  OrderStatus.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "OrderStatus.h"

@implementation OrderStatus

+ (OrderStatus *)getObjetFromApiResponse:(NSDictionary *)data
{
    OrderStatus *status = [[OrderStatus alloc] init];
    
    if (![data[@"updatedDateTime"] isKindOfClass:[NSNull class]])
    {
        status.updateDateTime = [status dateFromApiResponse:data[@"updatedDateTime"]];
    }
    
    status.state = [data[@"state"] integerValue];
    
    return status;
}

@end
