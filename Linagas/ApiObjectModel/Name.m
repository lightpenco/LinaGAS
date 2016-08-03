//
//  Name.m
//  Linagas
//
//  Created by Huxley on 30/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Name.h"

@implementation Name

+ (Name *)getObjetFromApiResponse:(NSDictionary *)data
{
    Name *name = [[Name alloc] init];
    
    name.firstName = [data[@"firstName"] isKindOfClass:[NSNull class]] ? @"" : data[@"firstName"];
    name.lastName = [data[@"lastName"] isKindOfClass:[NSNull class]] ? @"" : data[@"lastName"];
    name.middleName = [data[@"middleName"] isKindOfClass:[NSNull class]] ? @"" : data[@"middleName"];
    name.salutation = [data[@"salutation"] isKindOfClass:[NSNull class]] ? @"" : data[@"salutation"];
    name.businessName = [data[@"businessName"] isKindOfClass:[NSNull class]] ? @"" : data[@"businessName"];
    
    return name;
}

@end
