//
//  LastLocation.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
@import CoreLocation;

@interface LastLocation : BaseObject

@property (strong, nonatomic) NSDate *updatedDateTime;
@property (readwrite, nonatomic) CLLocationCoordinate2D location;

+ (LastLocation *)getObjetFromApiResponse:(NSDictionary *)data;

@end
