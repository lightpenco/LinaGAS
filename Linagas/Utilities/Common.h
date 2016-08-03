//
//  Common.h
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define iOS7                7
#define iOS7_1              7.1

#define screenHeight3_5inch 480
#define screenHeight4inch   568

#define screenLowDensity    1
#define screenHighDensity   2

#define kSectionHeader      @"kSectionHeader"
#define kSectionContent     @"kSectionContent"
#define kSectionFooter      @"kSectionFooter"

#define kLanguage           @"kLanguage"
#define extLproj            @"lproj"

#define kAnimationDuration 0.4
#define kAnimationDurationWithKeyboard 1.0

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

typedef NS_ENUM(NSInteger, iOSDevice)
{
    iPhone,
    iPad
};

@interface Common : NSObject

+ (UIStoryboard *)mainStoryboard;
+ (NSString *)bundleIdentifier;
+ (CGFloat)iOSVersion;
+ (UIUserInterfaceIdiom)iOSDevice;
+ (CGFloat)iOSScreenHeight;
+ (CGFloat)iOSScreenWidth;
+ (CGFloat)iOSScreenDensity;
+ (CGRect)statusBarFrame;
+ (UIInterfaceOrientation)statusBarOrientation;

+ (CGFloat)colorBrightness:(UIColor *)color;

+ (NSString *)productName;
+ (NSString *)productVersion;

+ (NSString *)applicationDocumentsDirectory;

+ (BOOL)keyExistsInDataCache:(NSString *)key;

+ (void)setInteger:(NSInteger)integer inDataCacheForKey:(NSString *)key;
+ (NSInteger)integerInDataCacheForKey:(NSString *)key;
+ (void)setFloat:(float)floatValue inDataCacheForKey:(NSString *)key;
+ (float)floatInDataCacheForKey:(NSString *)key;
+ (void)setDouble:(double)doubleValue inDataCacheForKey:(NSString *)key;
+ (double)doubleInDataCacheForKey:(NSString *)key;
+ (void)setBool:(BOOL)boolean inDataCacheForKey:(NSString *)key;
+ (BOOL)boolInDataCacheForKey:(NSString *)key;
+ (void)setObject:(id)object inDataCacheForKey:(NSString *)key;
+ (id)objectInDataCacheForKey:(NSString *)key;
+ (void)removeObjectFromDataCacheForKey:(NSString *)key;

+ (BOOL)URLSchemeExists:(NSString *)urlScheme;

+ (NSString *)getDateString:(NSDate *)date withFormat:(NSString *)format;
+ (NSDate *)getDateFromString:(NSString *)string withFormat:(NSString *)format;

+ (BOOL)validateEmailWithString:(NSString*)email;
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title withButtonTitle:(NSString *)buttonTitle;
+ (void)showConfirmation:(NSString *)message withTitle:(NSString *)title withCancelButtonTitle:(NSString *)cancel withOKButtonTitle:(NSString *)ok withDelegate:(id<UIAlertViewDelegate>)delegate withTag:(NSInteger)tag;
+ (void)showActionSheetInController:(UIViewController *)controller WithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate tag:(NSInteger)tag cancelButton:(NSString *)cancelButton desctructiveButton:(NSString *)destructiveButton otherTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

+ (void)delay:(void (^)())block by:(double)seconds;
+ (void)hideKeyboard;
+ (BOOL)isTextfieldEmpty:(UITextField *)textfield;
+ (void)listAllFonts;
+ (UIImage *)imageFromColor:(UIColor *)color;
+ (void)sendNotificationMessage:(NSString *)name withObject:(NSDictionary *)data;
+(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point;
+ (CIImage *)createQRForString:(NSString *)qrString scale:(CGFloat)scale;
+ (NSString *)getContentsOfFile:(NSString *)filename extension:(NSString *)extention;

#pragma mark - Data Source

+ (NSString *)getTitleForSection:(NSInteger)section fromData:(NSArray *)data;
+ (NSString *)getFooterForSection:(NSInteger)section fromData:(NSArray *)data;
+ (id)getRow:(NSIndexPath *)indexPath fromData:(NSArray *)data;
+ (NSInteger)numberOfRowsForSection:(NSInteger)section fromData:(NSArray *)data;

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
+ (NSData *)base64DataFromString:(NSString *)string;

+ (NSString *)camelCaseToTitleCase:(NSString *)string;

+ (NSString *)countryNameFromCode:(NSString *)countryCode;
+ (NSBundle *)setLanguage;

+ (void)getVideoThumbnail:(NSURL *)path completion:(void (^)(UIImage *image))completion;

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary;

+ (BOOL)stringHasNumberOnly:(NSString *)text;

+ (UIColor *)UIColorFromHex:(NSInteger)hex;
+ (UIColor *)UIColorFromHex:(NSInteger)hex alpha:(CGFloat)alpha;
+ (NSString *)stringByStrippingHTML:(NSString *)string;

#pragma mark - Animation

+ (void)runSpinAnimationOnView:(UIView *)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
+ (void)animatePopInOnView:(UIView *)view withDuration:(CGFloat)duration delay:(CGFloat)delay;
+ (void)animateFadeInOnView:(UIView *)view withDuration:(CGFloat)duration delay:(CGFloat)delay;

@end
