//
//  Provider.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "ApiModelObjects.h"

@import GoogleMaps;

@interface Provider : BaseObject

@property (strong, nonatomic) NSString *providerId;
@property (strong, nonatomic) NSDate *creationDate;
@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) LastLocation *lastLocation;
@property (strong, nonatomic) NSString *serviceOrganizationId;
@property (strong, nonatomic) NSArray *templateIds;
@property (strong, nonatomic) Name *name;
@property (strong, nonatomic) ServiceArea *serviceArea;
@property (strong, nonatomic) NSString *inventory;
@property (strong, nonatomic) Status *status;
@property (strong, nonatomic) RatingSummary *ratingSummary;
@property (strong, nonatomic) GMSMarker *marker;

+ (Provider *)getObjetFromApiResponse:(NSDictionary *)data;

@end