//
//  HelperFunction.h
//  SDYHotel
//
//  Created by admin on 2017/12/12.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#ifndef HelperFunction_h
#define HelperFunction_h

//GCD

void sdy_safeSyncDispatchToMainQueue(void(^block)(void));

void sdy_asyncDispatchToMainQueue(void(^block)(void));

void sdy_asyncDispatchToGlobalQueue(void(^block)(void));

void sdy_asyncDispatchToBackGroundQueue(void(^block)(void));

void sdy_delayeDispatchToMainQueue(NSTimeInterval, void(^block)(void));


// Method swizzling

#define SDYSwapInstanceMethodImplementation(selectorName) \
swapInstanceMethodImplementation(self, @selector(selectorName), @selector(swiz_ ## selectorName))
#define SDYSwapClassMethodImplementation(selectorName) \
swapClassMethodImplementation(self, @selector(selectorName), @selector(swiz_ ## selectorName))

/// Swap implementation of existing instance method with a new instance method implementation. Should only be called in the class' +load method.
void swapInstanceMethodImplementation(id object, SEL originalSelector, SEL newSelector);

/// Swap implementation of existing class method with a new class method implementation. Should only be called in the class' +load method.
void swapClassMethodImplementation(id object, SEL originalSelector, SEL newSelector);



#endif /* HelperFunction_h */
