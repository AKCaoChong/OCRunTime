//
//  UIAlertView+Block.m
//  EncodeDecode
//
//  Created by 曹冲 on 2018/5/10.
//  Copyright © 2018年 曹冲. All rights reserved.
//

#import "UIAlertView+Block.h"
#import <objc/runtime.h>

static const char alertKey;
static const char cancelKey;
@implementation UIAlertView (Block)

- (void)showWithBlock:(successBlock)block cancel:(cancelBlock)cancel{
    if (block) {
        objc_setAssociatedObject(self, &alertKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    if (cancel) {
        objc_setAssociatedObject(self, &cancelKey, cancel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    self.delegate = self;
    [self show];
}


- (void)alertView: (UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    successBlock block = objc_getAssociatedObject(self, &alertKey);
    block(buttonIndex);
}

- (void)alertViewCancel:(UIAlertView *)alertView{
    cancelBlock cancel = objc_getAssociatedObject(self, &cancelKey);
    cancel();
}

@end



















