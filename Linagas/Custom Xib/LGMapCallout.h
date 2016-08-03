//
//  LGMapCallout.h
//  Linagas
//
//  Created by Huxley Alcain on 8/3/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiModelObjects.h"

@interface LGMapCallout : UIView

@property (weak, nonatomic) IBOutlet UILabel *truck;
@property (weak, nonatomic) IBOutlet UILabel *company;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) Provider *provider;

@end
