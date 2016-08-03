//
//  KeyboardNotifier.h
//

#import <Foundation/Foundation.h>

@protocol KeyboardDelegate

@optional - (void)keyboardWillShow:(NSDictionary *)info;
@optional - (void)keyboardDidShow:(NSDictionary *)info;
@optional - (void)keyboardWillHide:(NSDictionary *)info;
@optional - (void)keyboardDidHide:(NSDictionary *)info;
@optional - (void)keyboardWillChangeFrame:(NSDictionary *)info;
@optional - (void)keyboardDidChangeFrame:(NSDictionary *)info;

@end

@interface KeyboardNotifier : NSObject

- (id)initWithDelegate:(id<KeyboardDelegate>)keyboardDelegate;

@property (readonly, nonatomic) BOOL visible;

@end
