//
//  Order.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (Order *)getObjetFromApiResponse:(NSDictionary *)data
{
    Order *order = [[Order alloc] init];
    
    if (![data[@"creationDateTime"] isKindOfClass:[NSNull class]])
    {
        order.creationDateTime = [order dateFromApiResponse:data[@"creationDateTime"]];
    }
    if (![data[@"scheduledDeliveryTime"] isKindOfClass:[NSNull class]])
    {
        order.scheduledDeliveryTime = [order dateFromApiResponse:data[@"scheduledDeliveryTime"]];
    }
    
    order.orderId = [data[@"id"] isKindOfClass:[NSNull class]] ? @"" : data[@"id"];
    order.orderStatus = [data[@"status"] isKindOfClass:[NSNull class]] ? nil : [OrderStatus getObjetFromApiResponse:data[@"status"]];
    order.serviceOrganizationId = [data[@"serviceOrganizationId"] isKindOfClass:[NSNull class]] ? @"" : data[@"serviceOrganizationId"];
    order.consumerId = [data[@"consumerId"] isKindOfClass:[NSNull class]] ? @"" : data[@"consumerId"];
    order.userId = [data[@"userId"] isKindOfClass:[NSNull class]] ? @"" : data[@"userId"];
    order.costCurrency = [data[@"costCurrency"] isKindOfClass:[NSNull class]] ? @"" : data[@"costCurrency"];
    order.orderType = [data[@"orderType"] integerValue];
    order.orderProcessingType = [data[@"orderProcessingType"] integerValue];
    order.totalCost = [data[@"totalCost"] floatValue];
    order.totalTax = [data[@"totalTax"] floatValue];
    order.itemsType = [data[@"itemsType"] integerValue];
    order.paymentResult = [data[@"paymentResult"] isKindOfClass:[NSNull class]] ? nil : [PaymentResult getObjetFromApiResponse:data[@"serviceOrganizationId"]];
    order.customerReview = [data[@"customerReview"] isKindOfClass:[NSNull class]] ? nil : [CustomerReview getObjetFromApiResponse:data[@"serviceOrganizationId"]];
    
    return order;
}

@end
