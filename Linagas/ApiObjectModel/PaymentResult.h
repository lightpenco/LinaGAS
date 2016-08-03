//
//  PaymentResult.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface PaymentResult : BaseObject

@property (strong, nonatomic) NSDate *creationDateTime;
@property (strong, nonatomic) NSDate *authorizationDateTime;
@property (readwrite, nonatomic) NSUInteger responseCode;
@property (strong, nonatomic) NSArray *data;

+ (PaymentResult *)getObjetFromApiResponse:(NSDictionary *)data;

@end