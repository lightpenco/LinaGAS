//
//  Name.h
//  Linagas
//
//  Created by Huxley on 30/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface Name : BaseObject

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *middleName;
@property (strong, nonatomic) NSString *salutation;
@property (strong, nonatomic) NSString *businessName;

+ (Name *)getObjetFromApiResponse:(NSDictionary *)data;

@end
