//
//  SDYCodingModel.m
//  SDYHotel
//
//  Created by admin on 2017/12/27.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "SDYCodingModel.h"

static NSString *userNameKey = @"SDYCodingModelUserNameKey";

@implementation SDYCodingModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _userName = [aDecoder decodeObjectForKey:userNameKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_userName forKey:userNameKey];
}



@end
