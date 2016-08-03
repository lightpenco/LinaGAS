//
//  RatingSummary.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "RatingSummary.h"

@implementation RatingSummary

+ (RatingSummary *)getObjetFromApiResponse:(NSDictionary *)data
{
    RatingSummary *ratingSummary = [[RatingSummary alloc] init];
    
    ratingSummary.cumulativeRating = [data[@"cumulativeRating"] integerValue];
    ratingSummary.cumulativeCount = [data[@"cumulativeCount"] integerValue];
    ratingSummary.rating = [data[@"rating"] integerValue];
    
    return ratingSummary;
}

@end
