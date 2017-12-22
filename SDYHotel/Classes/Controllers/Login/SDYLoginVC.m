//
//  SDYLoginVC.m
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYLoginVC.h"
#import "SDYTextField.h"


CGFloat textFieldHeight = 60;


@interface SDYLoginVC ()

@property (nonatomic) SDYTextField *userNameTextField;
@property (nonatomic) SDYTextField *passWorkTextField;
@property (nonatomic) UIButton *loginBtn;
@property (nonatomic) UIButton *cancelBtn;



@end

@implementation SDYLoginVC

#pragma mark - lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = kUIColorFromRGB(0xf0f0f0);
    
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passWorkTextField];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.cancelBtn];
    
    
    [self layoutWithAuto];
}



#pragma mark - event response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)loginBtnClick
{
    [self.view endEditing:YES];
    
    [APPCT showActivity];
    
    NSString *user = self.userNameTextField.text;
    NSString *passWord = self.passWorkTextField.text;
    
    if (user.length == 0 || passWord.length == 0) {
        
        [self alertTitle:@"账户或者密码不能为空" message:nil complete:nil];
        return;
    }
    
    __weak typeof(self)WeakSelf = self;
    
    [[AppContext sharedAppContext].netWorkService POST:kSDYNetWorkShopLoginUrl parameters:@{user_name:user,user_password:passWord} success:^(NSDictionary *data, NSString *errorDescription) {
        
        __strong typeof(WeakSelf)strongSelf = WeakSelf;

        NSInteger  requestState =   [data[status] integerValue];
        NSString *messageValue = data[message];
        
        if (requestState != 0) {
            [strongSelf alertTitle:@"登录失败" message:messageValue complete:nil];
            [APPCT hiddenActivity];
            return;
        }
        
        NSDictionary *dic = data[@"data"];
        
        APPCT.loginUser = [LoginUser cz_objWithDict:dic];
        APPCT.isLogin = YES;
        [strongSelf dismissViewControllerAnimated:YES completion:nil];
        [APPCT hiddenActivity];
    
    } fail:^(NSString *errorDescription) {
        [WeakSelf alertTitle:@"登录失败" message:errorDescription complete:nil];
        [APPCT hiddenActivity];
    }];
}

- (void)cancelBackView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - peivate medhtod


- (void)layoutWithAuto
{
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-50);
        make.width.mas_equalTo(self.view.width/2);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.passWorkTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.width.mas_equalTo(self.view.width/2);
        make.height.mas_equalTo(textFieldHeight);
        make.bottom.mas_equalTo(self.loginBtn.mas_top).mas_offset(-20);
    }];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.centerX.equalTo(self.passWorkTextField);
        make.bottom.mas_equalTo(self.passWorkTextField.mas_top).mas_offset(-20);
    }];
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).mas_offset(60);
        make.left.equalTo(self.view).mas_offset(60);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(50);
    }];
}


#pragma mark - Getter and Setter

- (SDYTextField *)userNameTextField
{
    if (!_userNameTextField) {
        
        _userNameTextField = [SDYTextField textFieldPlaceholder:@"账户" font:18 textColor:[UIColor blackColor]];
        _userNameTextField.leftView = [self textFieldLeftViewWithImageName:@"icon_account" size:CGSizeMake(leftViewWidth , leftViewHeight)];
        _userNameTextField.backgroundColor = [UIColor whiteColor];
        
    }
    return _userNameTextField;
}

- (SDYTextField *)passWorkTextField
{
    if (!_passWorkTextField) {
        _passWorkTextField = [SDYTextField textFieldPlaceholder:@"密码" font:18 textColor:[UIColor blackColor]];
        _passWorkTextField.leftView = [self textFieldLeftViewWithImageName:@"icon_password" size:CGSizeMake(leftViewWidth, leftViewHeight)];
        _passWorkTextField.secureTextEntry = YES;
        _passWorkTextField.backgroundColor = [UIColor whiteColor];
    }
    return _passWorkTextField;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton btnWithTitle:@"登录" font:18 textColor:[UIColor whiteColor] bgColor:kUIColorFromRGB(0x06ce8a)];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton btnWithTitle:@"取消" font:18 textColor:[UIColor whiteColor] bgColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        _cancelBtn.layer.cornerRadius = 20;
        [_cancelBtn addTarget:self action:@selector(cancelBackView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (UIImageView *)textFieldLeftViewWithImageName:(NSString *)imageName size:(CGSize)size
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = [UIImage sizeImageWithImage:[UIImage imageNamed:imageName] sizs:size];
    imageView.frame = CGRectMake(0, 0, size.width, size.height);
    return imageView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
