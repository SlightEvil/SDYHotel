//
//  UITextField+Category.m
//  SDYHotel
//
//  Created by admin on 2018/1/2.
//  Copyright © 2018年 SanDaoYi. All rights reserved.
//

#import "UITextField+Category.h"



@implementation UITextField (Category)


- (void)setupAccessoryViewWithDone:(NSString *)title
{
    self.inputAccessoryView = [self inputAccessoryViewToolbarTitle:title];
}


- (void)dismissKeyboard
{
    [self resignFirstResponder];
}

- (UIToolbar *)inputAccessoryViewToolbarTitle:(NSString *)title
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSString *titleStr = title ? title : @"设置";
    UIBarButtonItem *itemTitle = [[UIBarButtonItem alloc] initWithTitle:titleStr style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 40);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:self.tintColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    toolbar.items = @[itemTitle,itemSpace,doneItem];
    return toolbar;
}

@end
