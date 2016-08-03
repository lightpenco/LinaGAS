//
//  BaseObject.h
//  Linagas
//
//  Created by Huxley Alcain on 7/25/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SSKeychain/SSKeychain.h>
#import "AFNetworking.h"
#import "ApiDefinitions.h"
#import "Definitions.h"
#import "Common.h"
#import "ApiDefinitions.h"
#import "ErrorApiResponse.h"

typedef void (^LinagasSuccessBlock)(id response);
typedef void (^LinagasFailureBlock)(ErrorApiResponse *response);

@interface BaseObject : NSObject

- (NSDate *)dateFromApiResponse:(NSString *)dateString;
- (NSString *)dateStringFromDate:(NSDate *)date;

@end
