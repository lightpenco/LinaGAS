//
//  Order.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "ApiModelObjects.h"

@interface Order : BaseObject

@property (strong, nonatomic) NSString *orderId;
@property (strong, nonatomic) NSDate *creationDateTime;
@property (strong, nonatomic) NSDate *scheduledDeliveryTime;
@property (strong, nonatomic) NSString *serviceOrganizationId;
@property (readwrite, nonatomic) NSUInteger orderType;
@property (readwrite, nonatomic) NSUInteger orderProcessingType;
@property (strong, nonatomic) NSString *consumerId;
@property (strong, nonatomic) NSString *userId;
@property (readwrite, nonatomic) CGFloat totalCost;
@property (readwrite, nonatomic) CGFloat totalTax;
@property (strong, nonatomic) NSString *costCurrency;
@property (readwrite, nonatomic) NSUInteger itemsType;
@property (strong, nonatomic) OrderStatus *orderStatus;
@property (strong, nonatomic) PaymentResult *paymentResult;
@property (strong, nonatomic) CustomerReview *customerReview;

+ (Order *)getObjetFromApiResponse:(NSDictionary *)data;

@end
