//
//  Function.h
//  Seller
//
//  Created by admin on 2017/11/27.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Function : NSObject


/**
 根据文字 字体大小返回字体的size

 @param title title
 @param font font
 @return size
 */
+ (CGSize)sizeWithTitle:(NSString *)title font:(CGFloat)font;

/**
 *  压缩图片到指定大小
 *
 *  @param img  图片源
 *  @param size 指定的大小
 *  @return 返回压缩后的图片
 */
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;

/**
 先判断是不是 Null 后台反馈   在判断是不是nil  在判断是不是长度为0
 
 @param string string
 @return 判断string 是否为nil NULL @""
 */
+ (BOOL)isEmpty:(NSString *)string;


/**
 获取当前控制器

 @return return value description
 */
+ (UIViewController *)getCurrentVC;



@end
