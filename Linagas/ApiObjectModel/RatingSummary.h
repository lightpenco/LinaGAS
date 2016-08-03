//
//  RatingSummary.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface RatingSummary : BaseObject

@property (readwrite, nonatomic) NSUInteger cumulativeRating;
@property (readwrite, nonatomic) NSUInteger cumulativeCount;
@property (readwrite, nonatomic) NSUInteger rating;

+ (RatingSummary *)getObjetFromApiResponse:(NSDictionary *)data;

@end