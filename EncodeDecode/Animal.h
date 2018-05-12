//
//  Animal.h
//  EncodeDecode
//
//  Created by 曹冲 on 2018/5/9.
//  Copyright © 2018年 曹冲. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animal : NSObject<NSCoding>

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) NSInteger age;
@property (nonatomic,strong) NSString *gender;

- (void)initWithPrivateVar:(NSString *)privateVar;

- (void)logOneAnimal;

@end
