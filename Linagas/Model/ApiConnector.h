//
//  ApiConnector.h
//  Linagas
//
//  Created by Huxley Alcain on 7/28/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface ApiConnector : BaseObject

- (void)changePassword:(NSString *)username email:(NSString *)email success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)claimAllocationWindow;
- (void)createApplication;
- (void)createConsumer:(NSString *)username password:(NSString *)password phone:(NSString *)phone country:(NSString *)country success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)createDelivery;
- (void)createOrder:(NSString *)sessionId ownerId:(NSString *)ownerId orderType:(NSUInteger)orderType orderProcessingType:(NSUInteger)orderProcessingType userId:(NSString *)userId totalCost:(NSUInteger)totalCost totalTax:(NSUInteger)totalTax costCurrency:(NSString *)costCurrency itemsType:(NSUInteger)itemsType  success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)createOrderItem:(NSString *)sessionId ownerId:(NSString *)ownerId quantity:(NSUInteger)quantity serviceItemId:(NSString *)serviceItemId orderId:(NSString *)orderId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)createPayment;
- (void)createServiceItem;
- (void)createServiceOrganization;
- (void)createServiceProvider;
- (void)createSession:(NSString *)username password:(NSString *)password success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)createUser;
- (void)deleteSession:(NSString *)sessionId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getAllocationWindows;
- (void)getApplication;
- (void)getConsumer;
- (void)getConsumers;
- (void)getContactForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getContactForServiceOrganization;
- (void)getContactForServiceProvider;
- (void)getCustomerInformation;
- (void)getDeliveriesForServiceOrganization;
- (void)getDeliveriesForServiceProvider;
- (void)getDeliveryDetails;
- (void)getDeliveryForOrder:(NSString *)sessionId ownerId:(NSString *)ownerId orderId:(NSString *)orderId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getFullInventory;
- (void)getNameForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getNameForServiceOrganization;
- (void)getNameForServiceProvider;
- (void)getOrder:(NSString *)sessionId ownerId:(NSString *)ownerId orderId:(NSString *)orderId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getOrderItem;
- (void)getOrderItems;
- (void)getOrderStatusAudits;
- (void)getOrders;
- (void)getOrdersForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getOrdersForServiceOrganization;
- (void)getOrdersForServiceProvider;
- (void)getProvidersForServiceOrganization;
- (void)getServiceItem;
- (void)getServiceItems;
- (void)getServiceOrganization;
- (void)getServiceOrganizations;
- (void)getServiceProvider:(NSString *)sessionId ownerId:(NSString *)ownerId providerId:(NSString *)providerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getServiceProviders:(NSString *)sessionId ownerId:(NSString *)ownerId country:(NSString *)country success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)getStatus;
- (void)getUser;
- (void)getUsersForConsumer;
- (void)refreshSession:(NSString *)sessionId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)registerServiceProvider;
- (void)rejectAllocationWindow;
- (void)requestPasswordReset:(NSString *)username email:(NSString *)email pin:(NSString *)pin newPassword:(NSString *)newPassword success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)requestVerificationPIN:(NSString *)sessionId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateAddress:(NSString *)sessionId ownerId:(NSString *)ownerId line1:(NSString *)line1 city:(NSString *)city postalCode:(NSString *)postalCode country:(NSString *)country success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateConsumerLocation:(NSString *)sessionId ownerId:(NSString *)ownerId dateTime:(NSString *)dateString lat:(CGFloat)lat lon:(CGFloat)lon success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateContactForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId name:(NSString *)name description:(NSString *)desc fax:(NSString *)fax  phone:(NSString *)phone email:(NSString *)email success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateContactForServiceOrganization;
- (void)updateContactForServiceProvider;
- (void)updateDeliveryStatus:(NSString *)sessionId ownerId:(NSString *)ownerId deliveryId:(NSString *)deliveryId date:(NSString *)date state:(NSUInteger)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateInventory;
- (void)updateNameForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId firstName:(NSString *)firstName lastName:(NSString *)lastName middleName:(NSString *)middleName salutation:(NSString *)salutation businessName:(NSString *)businessName success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateNameForServiceOrganization;
- (void)updateNameForServiceProvider;
- (void)updateOrderCustomerReview;
- (void)updateOrderStatus:(NSString *)sessionId ownerId:(NSString *)ownerId orderId:(NSString *)orderId date:(NSString *)date state:(NSUInteger)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateProviderDeliveryStatus;
- (void)updateProviderStatus;
- (void)updateServiceProviderCustomerReview:(NSString *)sessionId ownerId:(NSString *)ownerId deliveryId:(NSString *)deliveryId rating:(CGFloat)rating message:(NSString *)message success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)updateServiceProviderLocation;
- (void)updateUserLocation;
- (void)updateUserPassword:(NSString *)sessionId ownerId:(NSString *)ownerId oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)validateVerificationPIN:(NSString *)sessionId pin:(NSString *)pin success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;

@end
