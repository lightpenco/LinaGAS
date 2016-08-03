//
//  KeyboardNotifier.m
//

#import "KeyboardNotifier.h"
#import <UIKit/UIKit.h>

@interface KeyboardNotifier()

@property (weak, nonatomic) id<KeyboardDelegate> delegate;

- (void)registerForKeyboardNotifications;
- (void)unregisterKeyboardNotifications;
- (void)notifyView:(NSNotification *)notification;

@end

@implementation KeyboardNotifier

- (id)initWithDelegate:(id<KeyboardDelegate>)keyboardDelegate
{
    self = [[KeyboardNotifier alloc] init];
    if (self)
    {
        if (keyboardDelegate)
        {
            self.delegate = keyboardDelegate;
            [self registerForKeyboardNotifications];
        }
        
    }
    return self;
}

- (void)dealloc
{
    [self unregisterKeyboardNotifications];
}

- (void)registerForKeyboardNotifications
{
    id defaultCenter;
    
    defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter addObserver:self selector:@selector(notifyView:) name:UIKeyboardWillShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyView:) name:UIKeyboardDidShowNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyView:) name:UIKeyboardWillHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyView:) name:UIKeyboardDidHideNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [defaultCenter addObserver:self selector:@selector(notifyView:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

- (void)unregisterKeyboardNotifications
{
    id defaultCenter;
    
    defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self];
}

- (void)notifyView:(NSNotification *)notification
{
    if (_delegate)
    {
        NSDictionary *info;
        info = [notification userInfo];
        
        if ([notification.name isEqualToString:UIKeyboardWillShowNotification])
        {
            if ([(NSObject *)_delegate respondsToSelector:@selector(keyboardWillShow:)])
            {
                [_delegate keyboardWillShow:info];
            }
        }
        else if ([notification.name isEqualToString:UIKeyboardDidShowNotification])
        {
            _visible = YES;
            if ([(NSObject *)_delegate respondsToSelector:@selector(keyboardDidShow:)])
            {
                [_delegate keyboardDidShow:info];
            }
        }
        else if ([notification.name isEqualToString:UIKeyboardWillHideNotification])
        {
            if ([(NSObject *)_delegate respondsToSelector:@selector(keyboardWillHide:)])
            {
                [_delegate keyboardWillHide:info];
            }
        }
        else if ([notification.name isEqualToString:UIKeyboardDidHideNotification])
        {
            _visible = NO;
            if ([(NSObject *)_delegate respondsToSelector:@selector(keyboardDidHide:)])
            {
                [_delegate keyboardDidHide:info];
            }
        }
        else if ([notification.name isEqualToString:UIKeyboardWillChangeFrameNotification])
        {
            if ([(NSObject *)_delegate respondsToSelector:@selector(keyboardWillChangeFrame:)])
            {
                [_delegate keyboardWillChangeFrame:info];
            }
        }
        else if ([notification.name isEqualToString:UIKeyboardDidChangeFrameNotification])
        {
            if ([(NSObject *)_delegate respondsToSelector:@selector(keyboardDidChangeFrame:)])
            {
                [_delegate keyboardDidChangeFrame:info];
            }
        }
    }
}

@end
