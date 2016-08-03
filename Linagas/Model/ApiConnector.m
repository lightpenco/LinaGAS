//
//  ApiConnector.m
//  Linagas
//
//  Created by Huxley Alcain on 7/28/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "ApiConnector.h"
#import "ErrorApiResponse.h"

@interface ApiConnector()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end

@implementation ApiConnector

#pragma mark - REST CLIENT

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    
    return self;
}

- (void)initializedManagerSerializer
{
    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [_manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_manager.requestSerializer setValue:kApplicationID forHTTPHeaderField:kParamApplicationId];
}

- (ErrorApiResponse *)serializeFailureResponse:(NSError *)error
{
    ErrorApiResponse *errorApiResponse;
    
    if (error.code != NSURLErrorTimedOut && error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey])
    {
        NSDictionary *response;
        
        response = [NSJSONSerialization JSONObjectWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                   options:kNilOptions
                                                     error:nil];
        errorApiResponse = [ErrorApiResponse getObjetFromApiResponse:response];
    }
    
    return errorApiResponse;
}

- (void)Post:(NSString *)url parameters:(NSDictionary *)param headers:(NSDictionary *)headers success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [self initializedManagerSerializer];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [_manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self serializeFailureResponse:error]);
    }];
}

- (void)Put:(NSString *)url parameters:(NSDictionary *)param headers:(NSDictionary *)headers success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [self initializedManagerSerializer];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [_manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self serializeFailureResponse:error]);
    }];
}

- (void)Get:(NSString *)url headers:(NSDictionary *)headers success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [self initializedManagerSerializer];
    [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [_manager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    [_manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self serializeFailureResponse:error]);
    }];
}

#pragma mark - API Methods

- (void)changePassword:(NSString *)username email:(NSString *)email success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"userName" : username,
                            @"email" : email};
    
    [self Post:PasswordResetRequestUrl parameters:param headers:nil success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)claimAllocationWindow
{
    
}

- (void)createApplication
{
    
}

- (void)createConsumer:(NSString *)username password:(NSString *)password phone:(NSString *)phone country:(NSString *)country success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{
                            @"name": @{
                                    @"firstName": @"",
                                    @"lastName": @""
                                    },
                            @"address": @{
                                    @"line1": @"",
                                    @"city": @"",
                                    @"postalCode": @"",
                                    @"country": country
                                    },
                            @"contact": @{
                                    @"name": username,
                                    @"phone": phone,
                                    @"email": @""
                                    }
                            };
    
    NSDictionary *headers = @{kParamUsername : username,
                              kParamPassword : password};
    
    [self Post:SignupUrl parameters:param headers:headers success:^(NSDictionary *response) {
        
    } failure:^(ErrorApiResponse *response) {
        
    }];
}

- (void)createDelivery
{
    
}

- (void)createOrder:(NSString *)sessionId ownerId:(NSString *)ownerId orderType:(NSUInteger)orderType orderProcessingType:(NSUInteger)orderProcessingType userId:(NSString *)userId totalCost:(NSUInteger)totalCost totalTax:(NSUInteger)totalTax costCurrency:(NSString *)costCurrency itemsType:(NSUInteger)itemsType  success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"orderType" : [NSString stringWithFormat:@"%zd", orderType],
                            @"orderProcessingType" : [NSString stringWithFormat:@"%zd", orderProcessingType],
                            @"consumerId" : ownerId,
                            @"userId" : userId,
                            @"totalCost" : [NSString stringWithFormat:@"%zd", totalCost],
                            @"totalTax" : [NSString stringWithFormat:@"%zd", totalTax],
                            @"costCurrency" : costCurrency,
                            @"itemsType" : [NSString stringWithFormat:@"%zd", itemsType]};
    
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Post:OrderUrl parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)createOrderItem:(NSString *)sessionId ownerId:(NSString *)ownerId quantity:(NSUInteger)quantity serviceItemId:(NSString *)serviceItemId orderId:(NSString *)orderId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"quantity" : [NSString stringWithFormat:@"%zd", quantity],
                            @"serviceItemId" : serviceItemId,
                            @"orderId" : orderId};
    

    
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Post:[NSString stringWithFormat:OrderItemUrl, orderId] parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
    
}

- (void)createPayment
{
    
}

- (void)createServiceItem
{
    
}

- (void)createServiceOrganization
{
    
}

- (void)createServiceProvider
{
    
}

- (void)createSession:(NSString *)username password:(NSString *)password success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"userName" : username,
                            @"password" : password};
    
    [self Post:LoginUrl parameters:param headers:nil success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)createUser
{
    
}

- (void)deleteSession:(NSString *)sessionId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"id" : sessionId};
    
    [self Put:LoginUrl parameters:param headers:nil success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getAllocationWindows
{
    
}

- (void)getApplication
{
    
}

- (void)getConsumer
{
    
}

- (void)getConsumers
{
    
}

- (void)getContactForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:ContactOfCustomerUrl, ownerId]  headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getContactForServiceOrganization
{
    
}

- (void)getContactForServiceProvider
{
    
}

- (void)getCustomerInformation
{
    
}

- (void)getDeliveriesForServiceOrganization
{
    
}

- (void)getDeliveriesForServiceProvider
{
    
}

- (void)getDeliveryDetails
{
    
}

- (void)getDeliveryForOrder:(NSString *)sessionId ownerId:(NSString *)ownerId orderId:(NSString *)orderId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:OrderDeliveryUrl, orderId] headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getFullInventory
{
    
}

- (void)getNameForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:NameOfCustomerUrl, ownerId]  headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getNameForServiceOrganization
{
    
}

- (void)getNameForServiceProvider
{
    
}

- (void)getOrder:(NSString *)sessionId ownerId:(NSString *)ownerId orderId:(NSString *)orderId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:OrderDetailsUrl, orderId]  headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getOrderItem
{
    
}

- (void)getOrderItems
{
    
}

- (void)getOrderStatusAudits
{
    
}

- (void)getOrders
{
    
}

- (void)getOrdersForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:OrdersOfCustomerUrl, ownerId]  headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getOrdersForServiceOrganization
{
    
}

- (void)getOrdersForServiceProvider
{
    
}

- (void)getProvidersForServiceOrganization
{
    
}

- (void)getServiceItem
{
    
}

- (void)getServiceItems
{
    
}

- (void)getServiceOrganization
{
    
}

- (void)getServiceOrganizations
{
    
}

- (void)getServiceProvider:(NSString *)sessionId ownerId:(NSString *)ownerId providerId:(NSString *)providerId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:ServiceProviderUrl, providerId]  headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getServiceProviders:(NSString *)sessionId ownerId:(NSString *)ownerId country:(NSString *)country success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{kParamSessionId : sessionId};
    
    [self Get:[NSString stringWithFormat:ServiceProvidersUrl, country]  headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)getStatus
{
    
}

- (void)getUser
{
    
}

- (void)getUsersForConsumer
{
    
}

- (void)refreshSession:(NSString *)sessionId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *headers = @{@"id" : sessionId};
    
    [self Get:LoginUrl headers:headers success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)registerServiceProvider
{
    
}

- (void)rejectAllocationWindow
{
    
}

- (void)requestPasswordReset:(NSString *)username email:(NSString *)email pin:(NSString *)pin newPassword:(NSString *)newPassword success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"userName" : username,
                            @"email" : email,
                            @"pinToMatch" : pin,
                            @"newPass" : newPassword};
    
    [self Post:PasswordResetUrl parameters:param headers:nil success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)requestVerificationPIN:(NSString *)sessionId success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [self Post:[NSString stringWithFormat:RequestVerificationPinUrl, sessionId] parameters:nil headers:nil success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateAddress:(NSString *)sessionId ownerId:(NSString *)ownerId line1:(NSString *)line1 city:(NSString *)city postalCode:(NSString *)postalCode country:(NSString *)country success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"line1" : line1,
                            @"city" : city,
                            @"postalCode" : postalCode,
                            @"country" : country};
    
    NSDictionary *header = @{kParamSessionId : sessionId};
   
    [self Put:[NSString stringWithFormat:AddressOfCustomerUrl, ownerId] parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateConsumerLocation:(NSString *)sessionId ownerId:(NSString *)ownerId dateTime:(NSString *)dateString lat:(CGFloat)lat lon:(CGFloat)lon success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"updatedDateTime" : dateString,
                            @"latitude" : [NSString stringWithFormat:@"%f", lat],
                            @"longitude" : [NSString stringWithFormat:@"%f", lon]};
    
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:LocationOfCustomerUrl, ownerId] parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
    
}

- (void)updateContactForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId name:(NSString *)name description:(NSString *)desc fax:(NSString *)fax  phone:(NSString *)phone email:(NSString *)email success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"name": name,
                            @"description": desc,
                            @"fax": fax,
                            @"phone": phone,
                            @"email": email};
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:ContactOfCustomerUrl, ownerId] parameters:param headers:header success:^(id response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateContactForServiceOrganization
{
    
}

- (void)updateContactForServiceProvider
{
    
}

- (void)updateDeliveryStatus:(NSString *)sessionId ownerId:(NSString *)ownerId deliveryId:(NSString *)deliveryId date:(NSString *)date state:(NSUInteger)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"state" : [NSString stringWithFormat:@"%zd", state]};
    
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:DeliveryStatusUrl, deliveryId] parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateInventory
{
    
}

- (void)updateNameForConsumer:(NSString *)sessionId ownerId:(NSString *)ownerId firstName:(NSString *)firstName lastName:(NSString *)lastName middleName:(NSString *)middleName salutation:(NSString *)salutation businessName:(NSString *)businessName success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"firstName": firstName,
                            @"lastName": lastName,
                            @"middleName": middleName,
                            @"salutation": salutation,
                            @"businessName": businessName};
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:NameOfCustomerUrl, ownerId] parameters:param headers:header success:^(id response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateNameForServiceOrganization
{
    
}

- (void)updateNameForServiceProvider
{
    
}

- (void)updateOrderCustomerReview
{
    
}

- (void)updateOrderStatus:(NSString *)sessionId ownerId:(NSString *)ownerId orderId:(NSString *)orderId date:(NSString *)date state:(NSUInteger)state success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"state" : [NSString stringWithFormat:@"%zd", state]};
    
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:OrderStatusUrl, orderId] parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateProviderDeliveryStatus
{
    
}

- (void)updateProviderStatus
{
    
}

- (void)updateServiceProviderCustomerReview:(NSString *)sessionId ownerId:(NSString *)ownerId deliveryId:(NSString *)deliveryId rating:(CGFloat)rating message:(NSString *)message success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"feedback" : @[@{@"message" : message}]};
    
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:DeliveryReviewUrl, deliveryId] parameters:param headers:header success:^(NSDictionary *response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)updateServiceProviderLocation
{
    
}

- (void)updateUserLocation
{
    
}

- (void)updateUserPassword:(NSString *)sessionId ownerId:(NSString *)ownerId oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    NSDictionary *param = @{@"oldPassword": oldPassword,
                            @"newPassword": newPassword};
    NSDictionary *header = @{kParamSessionId : sessionId};
    
    [self Put:[NSString stringWithFormat:ChangeUserPasswordUrl, ownerId] parameters:param headers:header success:^(id response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

- (void)validateVerificationPIN:(NSString *)sessionId pin:(NSString *)pin success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure
{
    [self Put:[NSString stringWithFormat:VerificationPinUrl, sessionId, pin] parameters:nil headers:nil success:^(id response) {
        success(response);
    } failure:^(ErrorApiResponse *response) {
        failure(response);
    }];
}

@end