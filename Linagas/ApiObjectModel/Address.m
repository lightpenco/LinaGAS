//
//  Address.m
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Address.h"

@implementation Address

+ (Address *)getObjetFromApiResponse:(NSDictionary *)data
{
    Address *address = [[Address alloc] init];
    
    address.stateCode = [data[@"stateCode"] isKindOfClass:[NSNull class]] ? @"" : data[@"stateCode"];
    address.line1 = [data[@"line1"] isKindOfClass:[NSNull class]] ? @"" : data[@"line1"];
    address.line2 = [data[@"line2"] isKindOfClass:[NSNull class]] ? @"" : data[@"line2"];
    address.line3 = [data[@"line3"] isKindOfClass:[NSNull class]] ? @"" : data[@"line3"];
    address.city = [data[@"city"] isKindOfClass:[NSNull class]] ? @"" : data[@"city"];
    address.postalCode = [data[@"postalCode"] isKindOfClass:[NSNull class]] ? @"" : data[@"postalCode"];
    address.country = [data[@"country"] isKindOfClass:[NSNull class]] ? @"" : data[@"country"];
    
    return address;
}

@end
