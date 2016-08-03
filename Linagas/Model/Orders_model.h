//
//  Orders_model.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "ApiModelObjects.h"

@interface Orders_model : BaseObject

- (void)getOrder:(NSString *)orderId WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getOrderDelivery:(NSString *)orderId WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)postOrder:(Order *)order quantity:(NSUInteger)quantity WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)postOrderStatus:(Order *)order state:(ORDER_VALID_STATES)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)postDeliveryStatus:(NSString *)deliveryId state:(ORDER_VALID_STATES)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)postDeliveryReview:(NSString *)deliveryId rating:(CustomerReview *)rating success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;

@end
