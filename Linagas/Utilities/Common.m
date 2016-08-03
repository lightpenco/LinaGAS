//
//  Common.m
//

#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "AppDelegate.h"

@implementation Common

+ (UIStoryboard *)mainStoryboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (NSString *)bundleIdentifier
{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (CGFloat)iOSVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (UIUserInterfaceIdiom)iOSDevice
{
    return [[UIDevice currentDevice] userInterfaceIdiom];
}

+ (CGFloat)iOSScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)iOSScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)iOSScreenDensity;
{
    return [UIScreen mainScreen].scale;
}

+ (CGRect)statusBarFrame
{
    return [[UIApplication sharedApplication] statusBarFrame];
}

+ (UIInterfaceOrientation)statusBarOrientation
{
    return [[UIApplication sharedApplication] statusBarOrientation];
}

+ (CGFloat)colorBrightness:(UIColor *)color
{
    const CGFloat *componentColors;
    
    componentColors = CGColorGetComponents(color.CGColor);
    
    return color ? ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000 : 0;
}

+ (NSString *)productName
{
    NSString *productName;
    productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if ([productName length] == 0)
    {
        productName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    return productName;
}

+ (NSString *)productVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    return basePath;
}

+ (BOOL)keyExistsInDataCache:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key] != nil;
}

+ (void)setInteger:(NSInteger)integer inDataCacheForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setInteger:integer forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)integerInDataCacheForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (void)setFloat:(float)floatValue inDataCacheForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setFloat:floatValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (float)floatInDataCacheForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] floatForKey:key];
}

+ (void)setDouble:(double)doubleValue inDataCacheForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setDouble:doubleValue forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (double)doubleInDataCacheForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] doubleForKey:key];
}

+ (void)setBool:(BOOL)boolean inDataCacheForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:boolean forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)boolInDataCacheForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setObject:(id)object inDataCacheForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)objectInDataCacheForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)removeObjectFromDataCacheForKey:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)URLSchemeExists:(NSString *)URLScheme
{
    NSArray *URLSchemeArrays;
    
    URLSchemeArrays = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"] valueForKey:@"CFBundleURLSchemes"];
    
    if ([URLSchemeArrays count] > 0)
    {
        __block NSMutableArray *URLSchemes;
        URLSchemes = [NSMutableArray array];
        
        [URLSchemeArrays enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
         {
             if ([obj isKindOfClass:[NSArray class]])
             {
                 [URLSchemes addObjectsFromArray:obj];
             }
         }];
        
        if ([URLSchemes count] > 0)
        {
            return [URLSchemes indexOfObject:URLScheme] != NSNotFound;
        }
    }
    return NO;
}

+ (NSString *)getDateString:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *dateFormat;
    NSString *dateString;
    
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormat setDateFormat:format];
    
    dateString = [dateFormat stringFromDate:date];
    
    return dateString;
}

+ (NSDate *)getDateFromString:(NSString *)string withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    [dateFormatter setDateFormat:format];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    return [dateFormatter dateFromString:string];
}

+ (void)exchangeKey:(NSString *)oldKey withKey:(NSString *)newKey inMutableDictionary:(NSMutableDictionary *)dictionary
{
    if (![oldKey isEqualToString:newKey])
    {
        [dictionary setObject:[dictionary objectForKey:oldKey] forKey:newKey];
        [dictionary removeObjectForKey:oldKey];
    }
}

+ (BOOL)validateEmailWithString:(NSString*)email
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"] evaluateWithObject:email];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title withButtonTitle:(NSString *)buttonTitle
{
    [[[UIAlertView alloc] initWithTitle:title ? title : @"" message:message delegate:nil cancelButtonTitle:buttonTitle ? buttonTitle : @"OK" otherButtonTitles:nil] show];
}

+ (void)showConfirmation:(NSString *)message withTitle:(NSString *)title withCancelButtonTitle:(NSString *)cancel withOKButtonTitle:(NSString *)ok withDelegate:(id<UIAlertViewDelegate>)delegate withTag:(NSInteger)tag
{
    UIAlertView *confirm;
    
    confirm = [[UIAlertView alloc] initWithTitle:title ? title : @"" message:message delegate:delegate cancelButtonTitle:cancel otherButtonTitles:ok, nil];
    confirm.tag = tag;
    [confirm show];
}

+ (void)showActionSheetInController:(UIViewController *)controller WithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate tag:(NSInteger)tag cancelButton:(NSString *)cancelButton desctructiveButton:(NSString *)destructiveButton otherTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:delegate
                                                    cancelButtonTitle:cancelButton
                                               destructiveButtonTitle:destructiveButton
                                                    otherButtonTitles:nil];
    
    va_list args;
    va_start(args, otherButtonTitles);
    for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
    {
        [actionSheet addButtonWithTitle:arg];
    }
    va_end(args);
    
    actionSheet.tag = tag;
    [actionSheet showInView:controller.view];
}

+ (void)delay:(void (^)())block by:(double)seconds
{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

+ (UIColor *)UIColorFromHex:(NSInteger)hex
{
    return [self UIColorFromHex:hex alpha:1.0];
}

+ (UIColor *)UIColorFromHex:(NSInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:alpha];
}

+ (NSString *)stringByStrippingHTML:(NSString *)string
{
    NSRange range;
    while ((range = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    while ((range = [string rangeOfString:@"&nbsp;\n"]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    while ((range = [string rangeOfString:@"&nbsp;"]).location != NSNotFound)
        string = [string stringByReplacingCharactersInRange:range withString:@""];
    return string;
}

+ (void)hideKeyboard
{
    [[UIApplication sharedApplication].keyWindow.rootViewController.view endEditing:YES];
}

+ (BOOL)isTextfieldEmpty:(UITextField *)textfield
{
    NSString *rawString = [textfield text];
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [rawString stringByTrimmingCharactersInSet:whitespace];
    return [trimmed length] == 0;
}

+ (void)listAllFonts
{
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)sendNotificationMessage:(NSString *)name withObject:(NSDictionary *)data
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:data];
}

+(UIImage*)drawFront:(UIImage*)image text:(NSString*)text atPoint:(CGPoint)point
{
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:21];
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, (point.y - 5), image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = NSMakeRange(0, [attString length]);
    
    [attString addAttribute:NSFontAttributeName value:font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
    
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor darkGrayColor];
    shadow.shadowOffset = CGSizeMake(1.0f, 1.5f);
    [attString addAttribute:NSShadowAttributeName value:shadow range:range];
    
    [attString drawInRect:CGRectIntegral(rect)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (NSString *)getContentsOfFile:(NSString *)filename extension:(NSString *)extention
{
    NSString* path = [[NSBundle mainBundle] pathForResource:filename
                                                     ofType:extention];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    return  content;
}

#pragma mark - QR Code

+ (CIImage *)createQRForString:(NSString *)qrString scale:(CGFloat)scale
{
    NSData *stringData = [qrString dataUsingEncoding: NSISOLatin1StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(scale, scale);
    
    return [qrFilter.outputImage imageByApplyingTransform: transform];
}

#pragma mark - Data Source

/**
 Data Structure
 {
 kSectionHeader:NSString
 kSectionContent:NSArray
 kSectionFooter:NSString
 }
 */

+ (NSString *)getTitleForSection:(NSInteger)section fromData:(NSArray *)data
{
    return [(NSDictionary *)[data objectAtIndex:section] objectForKey:kSectionHeader];
}

+ (NSString *)getFooterForSection:(NSInteger)section fromData:(NSArray *)data;
{
    return [(NSDictionary *)[data objectAtIndex:section] objectForKey:kSectionFooter];
}

+ (id)getRow:(NSIndexPath *)indexPath fromData:(NSArray *)data
{
    return [[(NSDictionary *)[data objectAtIndex:indexPath.section] objectForKey:kSectionContent] objectAtIndex:indexPath.row];
}

+ (NSInteger)numberOfRowsForSection:(NSInteger)section fromData:(NSArray *)data
{
    return [[(NSDictionary *)[data objectAtIndex:section] objectForKey:kSectionContent] count];
}

#pragma mark - Base64

static char base64EncodingTable[64] =
{
    'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
    'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
    'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
    'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};

+ (NSString *)base64StringFromData:(NSData *)data length:(int)length
{
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
    {
        return @"";
    }
    
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true)
    {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
        {
            break;
        }
        for (i = 0; i < 3; i++)
        {
            unsigned long ix;
            
            ix = ixtext + i;
            input[i] = ix < lentext ? raw[ix] : 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining)
        {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
        {
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        }
        
        for (i = ctcopy; i < 4; i++)
        {
            [result appendString: @"="];
        }
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
        {
            charsonline = 0;
        }
    }
    return result;
}

+ (NSData *)base64DataFromString:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4] = {}, outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    
    return theData;
}

+ (NSString *)camelCaseToTitleCase:(NSString *)string
{
    NSMutableString *newString = [NSMutableString string];
    
    for (NSInteger i = 0; i < string.length; i++)
    {
        NSString *ch = [string substringWithRange:NSMakeRange(i, 1)];
        if ([ch rangeOfCharacterFromSet:[NSCharacterSet uppercaseLetterCharacterSet]].location != NSNotFound)
        {
            [newString appendString:@" "];
        }
        [newString appendString:ch];
    }
    return newString;
}

+ (NSString *)countryNameFromCode:(NSString *)countryCode
{
    NSString *country;
    
    country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
    
    return [country length] > 0 ? country : @"";
}

+ (NSBundle *)setLanguage
{
    NSString *path;
    NSBundle *bundle;
    NSUserDefaults *dataCache;
    NSString *lang;
    
    dataCache = [NSUserDefaults standardUserDefaults];
    
    lang = [dataCache objectForKey:kLanguage];
    
    path = [[NSBundle mainBundle] pathForResource:lang ofType:extLproj];
    bundle = [NSBundle bundleWithPath:path];
    
    return bundle ? bundle : [NSBundle mainBundle];
}

+ (void)getVideoThumbnail:(NSURL *)path completion:(void (^)(UIImage *image))completion
{
    AVURLAsset *asset;
    AVAssetImageGenerator *generate;
    CMTime time;
    dispatch_queue_t queue;
    
    asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generate.appliesPreferredTrackTransform = YES;
    time = CMTimeMakeWithSeconds(0, 30);
    
    queue = dispatch_queue_create("thumbanilThread", NULL);
    dispatch_async(queue, ^
                   {
                       [generate generateCGImagesAsynchronouslyForTimes:@[[NSValue valueWithCMTime:time]] completionHandler:^(CMTime requestedTime, CGImageRef image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error)
                        {
                            if (completion && image)
                            {
                                completion(image ? [[UIImage alloc] initWithCGImage:image] : nil);
                            }
                        }];
                   });
}

+ (NSString *)jsonStringFromDictionary:(NSDictionary *)dictionary
{
    NSData *jsonData;
    
    jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (BOOL)stringHasNumberOnly:(NSString *)text
{
    return [[NSCharacterSet decimalDigitCharacterSet] isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:text]];
}

#pragma mark - Animation

+ (void)runSpinAnimationOnView:(UIView *)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

+ (void)animatePopInOnView:(UIView *)view withDuration:(CGFloat)duration delay:(CGFloat)delay
{
    view.alpha = 1.0;
    view.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}

+ (void)animateFadeInOnView:(UIView *)view withDuration:(CGFloat)duration delay:(CGFloat)delay
{
    view.alpha = 0.0;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        view.alpha = 1.0;
    } completion:^(BOOL finished){
        // if you want to do something once the animation finishes, put it here
    }];
}

@end
