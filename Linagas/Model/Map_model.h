//
//  Map_model.h
//  Linagas
//
//  Created by Huxley Alcain on 8/1/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "ApiModelObjects.h"

@interface Map_model : BaseObject

- (void)getProvidersWithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)setHomeLocation:(LastLocation *)location success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;
- (void)setHomeAddress:(Address *)address success:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;

@end
