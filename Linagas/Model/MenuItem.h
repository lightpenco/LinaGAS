//
//  MenuItem.h
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import <UIKit/UIKit.h>

@interface MenuItem : BaseObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *iconName;
@property (strong, nonatomic) NSString *selectorName;

@end
