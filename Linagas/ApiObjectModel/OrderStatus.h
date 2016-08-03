//
//  OrderStatus.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface OrderStatus : BaseObject

@property (readwrite, nonatomic) ORDER_VALID_STATES state;
@property (strong, nonatomic) NSDate *updateDateTime;

+ (OrderStatus *)getObjetFromApiResponse:(NSDictionary *)data;

@end
