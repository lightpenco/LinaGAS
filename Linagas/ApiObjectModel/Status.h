//
//  Status.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface Status : BaseObject

@property (readwrite, nonatomic) PROVIDER_VALID_STATES state;
@property (strong, nonatomic) NSDate *updateDateTime;

+ (Status *)getObjetFromApiResponse:(NSDictionary *)data;

@end
