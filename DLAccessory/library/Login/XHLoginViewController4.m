//
//  XHLoginViewController4.m
//  XHLogin
//
//  Created by 曾 宪华 on 13-12-12.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "XHLoginViewController4.h"

@interface XHLoginViewController4 ()

@end

@implementation XHLoginViewController4

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)dealloc
{
  self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.view.autoresizesSubviews = YES;
    
    _overlayView.frame = CGRectMake(0, 0,  CGRectGetWidth(self.view.bounds), 300.0f);

    _headerImageView.frame = CGRectMake(0, 0,  CGRectGetWidth(self.view.bounds), 300.0f);
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    _headerImageView.clipsToBounds = YES;
    
    _usernameField.frame = CGRectMake(0, CGRectGetMaxY(_headerImageView.frame),  CGRectGetWidth(self.view.bounds), 41);
    _passwordField.frame = CGRectMake(0, CGRectGetMaxY(_usernameField.frame),  CGRectGetWidth(self.view.bounds), 41);
    _loginButton.frame = CGRectMake(0, CGRectGetMaxY(_passwordField.frame),  CGRectGetWidth(self.view.bounds), 62);
    _forgotButton.frame = CGRectMake(25, CGRectGetMaxY(_loginButton.frame), 271, 19);
    _titleLabel.frame = CGRectMake(43, CGRectGetMaxY(_forgotButton.frame), 234, 60);
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
	self.edgesForExtendedLayout = UIRectEdgeAll;
    UIColor* mainColor = [UIColor colorWithRed:249.0/255 green:223.0/255 blue:244.0/255 alpha:1.0f];
    UIColor* darkColor = [UIColor colorWithRed:62.0/255 green:28.0/255 blue:55.0/255 alpha:1.0f];
    
    NSString* fontName = @"Avenir-Book";
    NSString* boldFontName = @"Avenir-Black";
    
    self.view.backgroundColor = mainColor;
    
    _usernameField = [[UITextField alloc] initWithFrame:CGRectMake(0, 220,  CGRectGetWidth(self.view.bounds), 41)];
    _usernameField.backgroundColor = [UIColor whiteColor];
    _usernameField.placeholder = @"Email Address";
    _usernameField.font = [UIFont fontWithName:fontName size:16.0f];
    _usernameField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    _usernameField.layer.borderWidth = 1.0f;
    
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    _usernameField.leftViewMode = UITextFieldViewModeAlways;
    _usernameField.leftView = leftView;
    
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(0, 260,  CGRectGetWidth(self.view.bounds), 41)];
    _passwordField.backgroundColor = [UIColor whiteColor];
    _passwordField.placeholder = @"Password";
    _passwordField.font = [UIFont fontWithName:fontName size:16.0f];
    _passwordField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.7].CGColor;
    _passwordField.layer.borderWidth = 1.0f;
    
    
    UIView* leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 41, 20)];
    _passwordField.leftViewMode = UITextFieldViewModeAlways;
    _passwordField.leftView = leftView2;
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 301,  CGRectGetWidth(self.view.bounds), 62)];
    _loginButton.backgroundColor = darkColor;
    _loginButton.titleLabel.font = [UIFont fontWithName:boldFontName size:20.0f];
    [_loginButton setTitle:@"SIGN UP HERE" forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginButton setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.5f] forState:UIControlStateHighlighted];
    
    _forgotButton = [[UIButton alloc] initWithFrame:CGRectMake(25, 382, 271, 19)];
    _forgotButton.backgroundColor = [UIColor clearColor];
    _forgotButton.titleLabel.font = [UIFont fontWithName:fontName size:12.0f];
    [_forgotButton setTitle:@"Forgot Password?" forState:UIControlStateNormal];
    [_forgotButton setTitleColor:darkColor forState:UIControlStateNormal];
    [_forgotButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(43, 97, 234, 60)];
    _titleLabel.textColor =  [UIColor whiteColor];
    _titleLabel.font =  [UIFont fontWithName:boldFontName size:24.0f];
    _titleLabel.text = @"GOOD TO SEE YOU";

    
    
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  CGRectGetWidth(self.view.bounds), 165)];
    _headerImageView.image = [UIImage imageNamed:@"test.jpg"];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [self.view addSubview:self.headerImageView];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.forgotButton];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end