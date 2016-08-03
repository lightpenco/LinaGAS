//
//  ServiceArea.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface ServiceArea : BaseObject

@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) NSArray *states;
@property (strong, nonatomic) NSArray *cities;
@property (strong, nonatomic) NSArray *postalCodes;

+ (ServiceArea *)getObjetFromApiResponse:(NSDictionary *)data;

@end
