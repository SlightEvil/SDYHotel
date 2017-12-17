//
//  FunctionDefines.h
//  SDYHotel
//
//  Created by admin on 2017/12/11.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#ifndef FunctionDefines_h
#define FunctionDefines_h


#define tableViewTagCommodityLibraryProductCategory     15001
#define tableViewTagCommodityLibraryProductClass        15002
#define tableViewTagCommodityLibraryProductOrder        15003


#define buttonTagCommodityLibraryProductDetailViewGrade     20000
#define buttonTagCommodityLibraryProductDetailViewUnit      20010
//#define tableViewTag
//#define tableViewTag
//#define tableViewTag



#pragma mark - Notification

#define Add_Observer(NtfName,SEL) [[NSNotificationCenter defaultCenter] addObserver:self selector:SEL name:NtfName object:nil]

#define Remove_Observer(NtfName) [[NSNotificationCenter defaultCenter] removeObserver:self name:NtfName object:nil]

#define Post_Observer(NtfName,message,dictionary) [[NSNotificationCenter defaultCenter] postNotificationName:NtfName object:message userInfo:dictionary]



#define kScreenWidth    CGRectGetWidth([UIScreen mainScreen].bounds)
#define kScreenHeight   CGRectGetHeight([UIScreen mainScreen].bounds)

#pragma mark - Color

#define SDYTitleViewColor               kUIColorFromRGB(0xf8f8f8)
#define SDYTabbarBarTintColor           kUIColorFromRGB(0xf8f8f8)

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kStrAppendStr(string,appendString) [string stringByAppendingString:appendString]


#pragma mark - 单例

// .h
#define single_interface(class) + (class *) shared##class;
// .m
// \ 代表下一行也属于宏
// ## 是分隔符

#define single_implementation(class) \
static class *_instance; \
\
+(class *)shared##class \
{ \
if (_instance == nil){ \
_instance = [[self alloc] init]; \
} \
return _instance; \
} \
\
+(id)allocWithZone:(NSZone *)zone \
{  \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+(id) copyWithZone:(NSZone *)zone \
{ \
return self; \
}




#endif /* FunctionDefines_h */
