//
//  LoginViewController.m
//  Linagas
//
//  Created by Huxley on 23/07/2016.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "LoginViewController.h"
#import "JVFloatLabeledTextField.h"
#import "KeyboardNotifier.h"
#import "Login_model.h"
#import "Profile_model.h"
#import "HomeViewController.h"

@interface LoginViewController()<UITextFieldDelegate, UIAlertViewDelegate, KeyboardDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIButton *toggleSigninSignupButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *signinSignupButton;

@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *verifyPasswordTextField;
@property (weak, nonatomic) IBOutlet JVFloatLabeledTextField *mobileNumberTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyPasswordTextFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobileNumberTextFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toggleSigninSignupButtonBottomPadding;

@property (strong, nonatomic) KeyboardNotifier *keyboardNotifier;
@property (strong, nonatomic) Login_model *login_model;
@property (strong, nonatomic) Profile_model *profile_model;

@property (readwrite, nonatomic) BOOL isLogin;
@property (readwrite, nonatomic) BOOL isForgotPassword;
@property (readwrite, nonatomic) BOOL isForgotPasswordWithPin;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.isLogin = YES;
    self.keyboardNotifier = [[KeyboardNotifier alloc] initWithDelegate:self];
    self.login_model = [[Login_model alloc] init];
    self.profile_model = [[Profile_model alloc] init];
    
    [self prepareUI];
    [self updateUIWithAnimation:NO];
    [self prepareObservers];
    
    if ([_login_model checkIfSessionValid])
    {
        [_login_model refereshSessionWithSuccess:^(id response) {
            
        } failure:^(ErrorApiResponse *response) {
            
        }];
        [self performSegueWithIdentifier:segue_homeVCWithoutAnimation sender:nil];
    }
}

#pragma mark - Preparations

- (void)prepareUI
{
    _logoImage.image = [UIImage imageNamed:@"logo.png"];
    _bgImage.image = [UIImage imageNamed:@"splash.png"];
    _signinSignupButton.layer.cornerRadius = 5.0;
}

- (void)updateUIWithAnimation:(BOOL)animated
{
    if (!_isForgotPassword)
    {
        [_signinSignupButton setTitle:_isLogin ? NSLocalizedString(@"Sign in", @"Sign in") : NSLocalizedString(@"Sign up", @"Sign up") forState:UIControlStateNormal];
        [_forgotPasswordButton setTitle:NSLocalizedString(@"Forgot Password", @"Forgot Password") forState:UIControlStateNormal];
        _usernameTextField.placeholder = NSLocalizedString(@"Username", @"Username");
        _passwordTextField.placeholder = NSLocalizedString(@"Password", @"Password");
        _verifyPasswordTextField.placeholder = NSLocalizedString(@"Verify Password", @"Verify Password");
        _mobileNumberTextField.placeholder = NSLocalizedString(@"Mobile Number", @"Mobile Number");
        
        _passwordTextField.secureTextEntry = YES;
        _verifyPasswordTextField.secureTextEntry = YES;
        _mobileNumberTextField.secureTextEntry = NO;
        
        _passwordTextField.keyboardType = UIKeyboardTypeAlphabet;
        _verifyPasswordTextField.keyboardType = UIKeyboardTypeAlphabet;
        _mobileNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _verifyPasswordTextFieldHeight.constant = _isLogin ? 0.0 : 40.0;
        _mobileNumberTextFieldHeight.constant = _verifyPasswordTextFieldHeight.constant;
    }
    else
    {
        [_signinSignupButton setTitle:NSLocalizedString(@"Send", @"Send") forState:UIControlStateNormal];
        [_forgotPasswordButton setTitle:NSLocalizedString(@"I have pin", @"I have pin") forState:UIControlStateNormal];
        
        _usernameTextField.placeholder = NSLocalizedString(@"Username", @"Username");
        _passwordTextField.placeholder = NSLocalizedString(@"Email", @"Email");
        _verifyPasswordTextField.placeholder = NSLocalizedString(@"Pin", @"Pin");
        _mobileNumberTextField.placeholder = NSLocalizedString(@"New Password", @"New Password");
        
        _passwordTextField.secureTextEntry = NO;
        _verifyPasswordTextField.secureTextEntry = NO;
        _mobileNumberTextField.secureTextEntry = YES;
        
        _passwordTextField.keyboardType = UIKeyboardTypeEmailAddress;
        _verifyPasswordTextField.keyboardType = UIKeyboardTypeNumberPad;
        _mobileNumberTextField.keyboardType = UIKeyboardTypeAlphabet;
        
        _verifyPasswordTextFieldHeight.constant = !_isForgotPasswordWithPin ? 0.0 : 40.0;
        _mobileNumberTextFieldHeight.constant = _verifyPasswordTextFieldHeight.constant;
    }
    
    [self.view needsUpdateConstraints];
    [UIView animateWithDuration:animated ? kAnimationDuration : 0 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)resetFields
{
    [self.view endEditing:YES];
    _usernameTextField.text = @"";
    _passwordTextField.text = @"";
    _verifyPasswordTextField.text = @"";
    _mobileNumberTextField.text = @"";
}

- (void)prepareObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogout:) name:kLogout object:nil];
}

#pragma mark - Observers

- (void)onLogout:(NSNotification *)notification
{
    [Common showConfirmation:NSLocalizedString(@"Are you sure you want to logout?", @"Are you sure you want to logout?")
                   withTitle:NSLocalizedString(@"Logout", @"Logout")
       withCancelButtonTitle:NSLocalizedString(@"NO", @"NO")
           withOKButtonTitle:NSLocalizedString(@"YES", @"YES")
                withDelegate:self
                     withTag:kTagAlertView_Logout];
}

#pragma mark - UIControls

- (IBAction)ontoggleSigninSignup:(id)sender
{
    self.isLogin = !_isLogin;
    if (_isForgotPassword)
    {
        self.isLogin = YES;
        self.isForgotPassword = NO;
        self.isForgotPasswordWithPin = NO;
    }
    
    [self updateUIWithAnimation:YES];
    [self resetFields];
}

- (IBAction)onForgotPassword:(id)sender
{
    if (!_isForgotPassword)
    {
        self.isForgotPassword = YES;
        self.isForgotPasswordWithPin = NO;
    }
    else if (!_isForgotPasswordWithPin)
    {
        self.isForgotPassword = YES;
        self.isForgotPasswordWithPin = YES;
        [_forgotPasswordButton setTitle:NSLocalizedString(@"Forgot Password", @"Forgot Password") forState:UIControlStateNormal];
    }
    else
    {
        self.isForgotPassword = YES;
        self.isForgotPasswordWithPin = NO;
    }
    [self updateUIWithAnimation:YES];
    [self resetFields];
}

- (IBAction)onSigninSignup:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
    
    if (!_isForgotPassword)
    {
        if (_isLogin)
        {
            [_login_model loginWithUsername:_usernameTextField.text password:_passwordTextField.text success:^(NSDictionary *response) {
                //Save session IDs, ownerId, and userId
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:response];
                [userInfo setObject:_passwordTextField.text forKey:@"password"];
                [_login_model saveUserInfo:userInfo];
                //proceed to home page
                [self loginSuccessful];
                [weakSelf hideAlertLoading];
            } failure:^(ErrorApiResponse *response) {
                [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
            }];
        }
        else
        {
            [_login_model signupWithUsername:_usernameTextField.text password:_passwordTextField.text mobileNumber:_mobileNumberTextField.text success:^(NSDictionary *response) {
                //Signup successful
                [_login_model loginWithUsername:_usernameTextField.text password:_passwordTextField.text success:^(NSDictionary *response) {
                    //Save session IDs, ownerId, and userId
                    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:response];
                    [userInfo setObject:_passwordTextField.text forKey:@"password"];
                    [_login_model saveUserInfo:userInfo];
                    [self loginSuccessful];
                    [weakSelf hideAlertLoading];
                } failure:^(ErrorApiResponse *response) {
                    [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
                }];
            } failure:^(ErrorApiResponse *response) {
                [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
            }];
        }
    }
    else
    {
        if (!_isForgotPasswordWithPin)
        {
            [_login_model requestPasswordReset:_usernameTextField.text email:_passwordTextField.text WithSuccess:^(id response) {
                [weakSelf hideAlertLoading];
                [weakSelf showAlertSuccess:NSLocalizedString(@"Password Reset", @"Password Reset") body:NSLocalizedString(@"Password reset pin is sent to your email. Use that email to change your password", @"Password reset pin is sent to your email. Use that pin to change your password.") closeButton:NSLocalizedString(@"OK", @"OK")];
                [self onForgotPassword:nil];
            } failure:^(ErrorApiResponse *response) {
                [weakSelf hideAlertLoading];
                [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
            }];
        }
        else
        {
            [_login_model postChangePassword:_usernameTextField.text
                                       email:_passwordTextField.text
                                         pin:_verifyPasswordTextField.text
                                 newPassword:_mobileNumberTextField.text
                                 WithSuccess:^(id response) {
                                     [weakSelf hideAlertLoading];
                                     [weakSelf showAlertError:NSLocalizedString(@"Password Reset", @"Password Reset") body:NSLocalizedString(@"Password changed successfully.", @"Password changed successfully.") closeButton:NSLocalizedString(@"OK", @"OK")];
                                 } failure:^(ErrorApiResponse *response) {
                                     [weakSelf hideAlertLoading];
                                     [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
                                 }];
        }
    }
}

- (void)loginSuccessful
{
    [self performSegueWithIdentifier:segue_homeVC sender:nil];
    [self resetFields];
    self.isLogin = YES;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == kTagAlertView_Logout)
    {
        if (buttonIndex != alertView.cancelButtonIndex)
        {
            __weak typeof(self) weakSelf = self;
            
            [self showAlertLoading:NSLocalizedString(@"Loading...", @"Loading...") body:NSLocalizedString(@"Please wait while we process your request...", @"Please wait while we process your request...")];
            
            [_login_model logoutUserWithSuccess:^(NSDictionary *response) {
                [weakSelf hideAlertLoading];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } failure:^(ErrorApiResponse *response) {
                [weakSelf showAlertError:NSLocalizedString(@"Error", @"Error") body:response.message closeButton:NSLocalizedString(@"OK", @"OK")];
            }];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL retVal;
    
    if (textField == _usernameTextField)
    {
        [_passwordTextField becomeFirstResponder];
    }
    else if (textField == _passwordTextField)
    {
        if (_isLogin)
        {
            [self onSigninSignup:nil];
        }
        else
        {
            [_verifyPasswordTextField becomeFirstResponder];
        }
    }
    else if (textField == _verifyPasswordTextField)
    {
        [_mobileNumberTextField becomeFirstResponder];
    }
    else if (textField == _mobileNumberTextField)
    {
        [self onSigninSignup:nil];
    }
    
    return retVal;
}

#pragma mark - KeyboardNotifier Delegate

- (void)keyboardWillHide:(NSDictionary *)info
{
    [self adjustUIWithKeyboard:NO offset:0];
}

- (void)keyboardWillShow:(NSDictionary *)info
{
    NSValue* keyboardFrameBegin = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    
    [self adjustUIWithKeyboard:[keyboardFrameBegin CGRectValue].size.height > 0 offset:[keyboardFrameBegin CGRectValue].size.height];
}

#pragma mark - Private Methods

- (void)adjustUIWithKeyboard:(BOOL)withKeyboard offset:(CGFloat)offset
{
    [self.view needsUpdateConstraints];
    [UIView animateWithDuration:kAnimationDuration animations:^{
        
        _toggleSigninSignupButtonBottomPadding.constant = withKeyboard ? offset : 30;
        
    } completion:^(BOOL finished) {
        
    }];
}

@end
