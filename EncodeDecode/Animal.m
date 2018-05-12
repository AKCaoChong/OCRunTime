//
//  Animal.m
//  EncodeDecode
//
//  Created by 曹冲 on 2018/5/9.
//  Copyright © 2018年 曹冲. All rights reserved.
//

#import "Animal.h"
#import <objc/runtime.h>

@interface Animal()

@property(nonatomic,strong) NSString *privateVar;

@end

@implementation Animal

- (void)initWithPrivateVar:(NSString *)privateVar{
    self.privateVar = privateVar;
}

//归档
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList([Animal class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

//反归档
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int outCount = 0;
        Ivar *ivars = class_copyIvarList([Animal class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return  self;
}

- (void)privateOneAnimal{
    NSLog(@"private One Animal");
}

- (void)logOneAnimal{
    NSLog(@"one animal");
}

/**
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([Animal class], &count); //获取所有的成员变量
    for (int i = 0; i < count; i++) {    //遍历所有的成员变量
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);  //获取成员变量名称
        NSString *key = [NSString stringWithUTF8String:name];  //以成员变量作为key值
        id value = [self valueForKey:key];  //键值对获取value值
        [aCoder encodeObject:value forKey:key];  //归档
    }
    free(ivars);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([Animal class], &count); //获取所有的成员变量
        for (int i = 0; i < count; i++) { //遍历所有的成员变量
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar); //获取成员变量名称
            NSString *key = [NSString stringWithUTF8String:name]; //以成员变量作为key值
            id value = [aDecoder decodeObjectForKey:key]; //反归档
            [self setValue:value forKey:key]; //键值对设置value值
        }
        free(ivars);
    }
    return self;
}
*/
@end
















