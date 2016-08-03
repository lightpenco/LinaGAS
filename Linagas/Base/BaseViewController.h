//
//  BaseViewController.h
//  Linagas
//
//  Created by Huxley on 23/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Definitions.h"
#import "Common.h"
#import "ApiModelObjects.h"
#import "MBProgressHUD.h"
#import "SCLAlertView.h"

@interface BaseViewController : UIViewController

- (void)addBlurEffectOnView:(UIView *)view withBlurStyle:(UIBlurEffectStyle)style;
- (void)showLoader:(BOOL)show inView:(UIView *)toView;

- (void)showAlertError:(NSString *)alertTitle body:(NSString *)body closeButton:(NSString *)closeButton;
- (void)showAlertSuccess:(NSString *)alertTitle body:(NSString *)body closeButton:(NSString *)closeButton;
- (void)showAlertLoading:(NSString *)alertTitle body:(NSString *)body;
- (void)hideAlertLoading;

@end
