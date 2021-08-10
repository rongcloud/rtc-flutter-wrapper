//
//  Macros.h
//  rongcloud_rtc_wrapper_plugin
//
//  Created by 潘铭达 on 2021/6/11.
//

#ifndef Macros_h
#define Macros_h

#define SingleInstanceH(name) + (instancetype)shared##name;

#define SingleInstanceM(name) static id instance = nil;\
\
+ (instancetype)shared##name {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [[self alloc] init];\
    });\
    return instance;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone {\
    static dispatch_once_t onceToken;\
    dispatch_once(&onceToken, ^{\
        instance = [super allocWithZone:zone];\
    });\
    return instance;\
}\
\
- (id)copyWithZone:(NSZone *)zone {\
    return instance;\
}\
\
- (id)mutableCopy {\
    return instance;\
}\

#endif /* Macros_h */
