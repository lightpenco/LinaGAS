//
//  Contact.h
//  Linagas
//
//  Created by Huxley on 30/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"

@interface Contact : BaseObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * desc;
@property (strong, nonatomic) NSString * fax;
@property (strong, nonatomic) NSString * phone;
@property (strong, nonatomic) NSString * email;

+ (Contact *)getObjetFromApiResponse:(NSDictionary *)data;

@end
