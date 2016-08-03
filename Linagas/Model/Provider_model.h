//
//  Provider_model.h
//  Linagas
//
//  Created by Huxley Alcain on 8/2/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "BaseObject.h"
#import "ApiModelObjects.h"

@interface Provider_model : BaseObject

- (void)getProvider:(NSString *)providerId WithSuccess:(LinagasSuccessBlock)success failure:(LinagasFailureBlock)failure;

@end
