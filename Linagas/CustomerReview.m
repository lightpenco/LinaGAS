//
//  CustomerReview.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "CustomerReview.h"

@implementation CustomerReview

+ (CustomerReview *)getObjetFromApiResponse:(NSDictionary *)data
{
    CustomerReview *customerReview = [[CustomerReview alloc] init];
    
    if (![data[@"creationDate"] isKindOfClass:[NSNull class]])
    {
        customerReview.creationDate = [customerReview dateFromApiResponse:data[@"creationDate"]];
    }
    
    customerReview.rating = [data[@"responseCode"] integerValue];
    customerReview.feedback = data[@"responseCode"];
    
    return customerReview;
}

@end
