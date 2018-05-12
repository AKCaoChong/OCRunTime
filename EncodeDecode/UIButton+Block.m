//
//  UIButton+Block.m
//  EncodeDecode
//
//  Created by 曹冲 on 2018/5/10.
//  Copyright © 2018年 曹冲. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>

@implementation UIButton (Block)

static const char btnKey;

- (void)handleWithBlock:(btnBlock)block{
    if (block) {
        objc_setAssociatedObject(self, &btnKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    btnBlock block = objc_getAssociatedObject(self, &btnKey);
    block();
}







@end













