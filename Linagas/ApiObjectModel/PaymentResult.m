//
//  PaymentResult.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "PaymentResult.h"

@implementation PaymentResult

+ (PaymentResult *)getObjetFromApiResponse:(NSDictionary *)data
{
    PaymentResult *paymentResult = [[PaymentResult alloc] init];
    
    if (![data[@"creationDateTime"] isKindOfClass:[NSNull class]])
    {
        paymentResult.creationDateTime = [paymentResult dateFromApiResponse:data[@"creationDateTime"]];
    }
    if (![data[@"authorizationDateTime"] isKindOfClass:[NSNull class]])
    {
        paymentResult.authorizationDateTime = [paymentResult dateFromApiResponse:data[@"authorizationDateTime"]];
    }
    
    paymentResult.responseCode = [data[@"responseCode"] integerValue];
    paymentResult.data = data[@"responseCode"];
    
    return paymentResult;
}

@end
