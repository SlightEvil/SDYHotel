//
//  UIImage+Category.m
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)


+ (UIImage *)sizeImageWithImage:(UIImage *)image sizs:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
     // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
     // 从当前context中创建一个改变大小后的图片
    UIImage *compleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();// 使当前的context出堆栈
    return compleImage;// 返回新的改变大小后的图片
}


@end
