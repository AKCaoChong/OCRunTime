//
//  UIAlertView+Block.h
//  EncodeDecode
//
//  Created by 曹冲 on 2018/5/10.
//  Copyright © 2018年 曹冲. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBlock)(NSInteger buttonIndex);
typedef void(^cancelBlock)();
@interface UIAlertView (Block)

- (void)showWithBlock:(successBlock)block cancel:(cancelBlock)cancel;

@end
