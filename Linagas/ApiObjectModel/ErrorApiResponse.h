//
//  ErrorApiResponse.h
//  Linagas
//
//  Created by Huxley Alcain on 8/3/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorApiResponse : NSObject

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *message;

+ (ErrorApiResponse *)getObjetFromApiResponse:(NSDictionary *)data;

@end
