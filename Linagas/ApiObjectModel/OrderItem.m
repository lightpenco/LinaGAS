//
//  OrderItem.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

+ (OrderItem *)getObjetFromApiResponse:(NSDictionary *)data
{
    OrderItem *orderItem = [[OrderItem alloc] init];
    
    orderItem.orderItemId = [data[@"id"] isKindOfClass:[NSNull class]] ? @"" : data[@"id"];
    orderItem.orderId = [data[@"orderId"] isKindOfClass:[NSNull class]] ? @"" : data[@"orderId"];
    orderItem.serviceItemId = [data[@"serviceItemId"] isKindOfClass:[NSNull class]] ? @"" : data[@"serviceItemId"];
    orderItem.quantity = [data[@"quantity"] integerValue];
    
    return orderItem;
}

@end
