//
//  OrderItem.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface OrderItem : BaseObject

@property (strong, nonatomic) NSString *orderItemId;
@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSString *serviceItemId;
@property (readwrite, nonatomic) NSUInteger quantity;

+ (OrderItem *)getObjetFromApiResponse:(NSDictionary *)data;

@end
