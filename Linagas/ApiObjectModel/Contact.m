//
//  Contact.m
//  Linagas
//
//  Created by Huxley on 30/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "Contact.h"

@implementation Contact

+ (Contact *)getObjetFromApiResponse:(NSDictionary *)data
{
    Contact *contact = [[Contact alloc] init];
    
    contact.name = [data[@"name"] isKindOfClass:[NSNull class]] ? @"" : data[@"name"];
    contact.desc = [data[@"description"] isKindOfClass:[NSNull class]] ? @"" : data[@"description"];
    contact.fax = [data[@"fax"] isKindOfClass:[NSNull class]] ? @"" : data[@"fax"];
    contact.phone = [data[@"phone"] isKindOfClass:[NSNull class]] ? @"" : data[@"phone"];
    contact.email = [data[@"email"] isKindOfClass:[NSNull class]] ? @"" : data[@"email"];
    
    return contact;
}

@end
