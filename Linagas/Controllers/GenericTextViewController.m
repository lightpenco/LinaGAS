//
//  GenericTextViewController.m
//  Linagas
//
//  Created by Huxley Alcain on 7/27/16.
//  Copyright © 2016 LightPenCo. All rights reserved.
//

#import "GenericTextViewController.h"

@interface GenericTextViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GenericTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = _titleName;
    _textView.text = _body;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.textView scrollRangeToVisible:NSMakeRange(0, 1)];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
