//
//  CustomerReview.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface CustomerReview : BaseObject

@property (strong, nonatomic) NSDate *creationDate;
@property (readwrite, nonatomic) NSUInteger rating;
@property (strong, nonatomic) NSArray *feedback;

+ (CustomerReview *)getObjetFromApiResponse:(NSDictionary *)data;

@end