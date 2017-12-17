//
//  UIImage+Category.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)


/**
 压缩图片到指定大小

 @param image 图片源
 @param size 指定的大小
 @return 返回压缩后的图片
 */
+ (UIImage *)sizeImageWithImage:(UIImage *)image sizs:(CGSize)size;

@end

