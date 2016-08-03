//
//  BaseObject.m
//  Linagas
//
//  Created by Huxley Alcain on 7/25/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

- (NSDate *)dateFromApiResponse:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"];
    
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)dateStringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    [dateFormatter setTimeZone:gmt];
    
    return [dateFormatter stringFromDate:date];
}

@end
