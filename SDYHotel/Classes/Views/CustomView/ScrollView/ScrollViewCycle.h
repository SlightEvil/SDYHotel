//
//  ScrollViewCycle.h
//  SDYHotel
//
//  Created by admin on 2017/12/22.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollViewCycle : UIView

@property (nonatomic) NSMutableArray *dataSourceImage;


- (void)startAnimation;

- (void)stopAnimation;

@end
