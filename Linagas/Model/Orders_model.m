//
//  Orders_model.m
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Orders_model.h"
#import "ApiConnector.h"

@interface Orders_model()

@property (strong, nonatomic) ApiConnector *apiConnector;

@end

@implementation Orders_model

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.apiConnector = [[ApiConnector alloc] init];
    }
    
    return self;
}

- (void)getOrder:(NSString *)orderId WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector getOrder:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                    ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                    orderId:orderId
                    success:^(id response) {
                        success([Order getObjetFromApiResponse:response]);
                    } failure:^(ErrorApiResponse *response) {
                        failure(response);
                    }];
}

- (void)getOrderDelivery:(NSString *)orderId WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector getDeliveryForOrder:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                    ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                    orderId:orderId
                    success:^(id response) {
                        success(response);
                    } failure:^(ErrorApiResponse *response) {
                        failure(response);
                    }];
}

- (void)postOrder:(Order *)order quantity:(NSUInteger)quantity WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector createOrder:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                       ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                     orderType:order.orderType
           orderProcessingType:order.orderProcessingType
                        userId:order.userId
                     totalCost:order.totalCost
                      totalTax:order.totalTax
                  costCurrency:order.costCurrency
                     itemsType:order.itemsType
                       success:^(id response) {
                           
                           Order *newOrder = [Order getObjetFromApiResponse:response];
                           [_apiConnector createOrderItem:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                                  ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                                 quantity:quantity
                                            serviceItemId:@"294010ce-a6ea-4ce4-8004-441c68066580"
                                                  orderId:newOrder.orderId
                                                  success:^(id response) {
                                                      
                                                      OrderItem *orderItem = [OrderItem getObjetFromApiResponse:response];
                                                      [_apiConnector getOrder:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                                                      ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                                                      orderId:orderItem.orderId
                                                                      success:^(id response) {
                                                                          Order *updatedOrder = [Order getObjetFromApiResponse:response];
                                                                          
                                                                          [_apiConnector updateOrderStatus:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                                                                                   ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                                                                                   orderId:updatedOrder.orderId
                                                                                                      date:[updatedOrder dateStringFromDate:[NSDate date]]
                                                                                                     state:1
                                                                                                   success:^(id response) {
                                                                                                       NSDictionary *data = @{@"orderItem" : orderItem,
                                                                                                                              @"order" : updatedOrder};
                                                                                                       success(data);
                                                                                                   } failure:^(ErrorApiResponse *response) {
                                                                                                       failure(response);
                                                                                                   }];
                                                                      } failure:^(ErrorApiResponse *response) {
                                                                          failure(response);
                                                                      }];
                                                  } failure:^(ErrorApiResponse *response) {
                                                      failure(response);
                                                  }];
                           
                       } failure:^(ErrorApiResponse *response) {
                           failure(response);
                       }];
}

- (void)postOrderStatus:(Order *)order state:(ORDER_VALID_STATES)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector updateOrderStatus:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                             ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                             orderId:order.orderId
                                date:nil
                               state:state
                             success:^(id response) {
                                 success(response);
                             } failure:^(ErrorApiResponse *response) {
                                 failure(response);
                             }];
}

- (void)postDeliveryStatus:(NSString *)deliveryId state:(ORDER_VALID_STATES)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector updateDeliveryStatus:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                             deliveryId:deliveryId
                                   date:nil
                                  state:state
                                success:^(id response) {
                                    success(response);
                                } failure:^(ErrorApiResponse *response) {
                                    failure(response);
                                }];
}

- (void)postDeliveryReview:(NSString *)deliveryId rating:(CustomerReview *)rating success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [_apiConnector updateServiceProviderCustomerReview:[SSKeychain passwordForService:kSessionID account:kApplicationID]
                                               ownerId:[SSKeychain passwordForService:kOwnerID account:kApplicationID]
                                            deliveryId:deliveryId
                                                rating:rating.rating
                                               message:rating.feedback[0][@"message"]
                                               success:^(id response) {
                                                   success(response);
                                               } failure:^(ErrorApiResponse *response) {
                                                   failure(response);
                                               }];
}

@end
