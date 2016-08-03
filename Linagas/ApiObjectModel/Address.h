//
//  Address.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface Address : BaseObject

@property (strong, nonatomic) NSString *stateCode;
@property (strong, nonatomic) NSString *line1;
@property (strong, nonatomic) NSString *line2;
@property (strong, nonatomic) NSString *line3;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *country;

+ (Address *)getObjetFromApiResponse:(NSDictionary *)data;

@end