//
//  ErrorApiResponse.m
//  Linagas
//
//  Created by Huxley Alcain on 8/3/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "ErrorApiResponse.h"

@implementation ErrorApiResponse

+ (ErrorApiResponse *)getObjetFromApiResponse:(NSDictionary *)data
{
    ErrorApiResponse *errorApiResponse = [[ErrorApiResponse alloc] init];
    
    errorApiResponse.code = [data[@"code"] isKindOfClass:[NSNull class]] ? @"" : data[@"code"];
    errorApiResponse.details = [data[@"details"] isKindOfClass:[NSNull class]] ? @"" : data[@"details"];
    errorApiResponse.message = [data[@"message"] isKindOfClass:[NSNull class]] ? @"" : data[@"message"];
    
    return errorApiResponse;
}

@end
