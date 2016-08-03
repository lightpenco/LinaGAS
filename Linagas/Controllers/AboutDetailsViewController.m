//
//  AboutDetailsViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/26/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "AboutDetailsViewController.h"
#import "SWRevealViewController.h"

@interface AboutDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *version;
@property (weak, nonatomic) IBOutlet UILabel *aboutText;

@end

@implementation AboutDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareUI
{
    _logo.image = [UIImage imageNamed:@"logo.png"];
    _version.text = [NSString stringWithFormat:@"v%@", [Common productVersion]];
    _aboutText.text = NSLocalizedString(@"LinaGAS modernizes the way gas trucks come to you. One tap and your order is received. No directions required. Bottles are promptly delivered to you.", @"About Text");
}

@end
