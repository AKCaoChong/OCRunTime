//
//  ViewController.m
//  EncodeDecode
//
//  Created by 曹冲 on 2018/5/9.
//  Copyright © 2018年 曹冲. All rights reserved.
//

#import "ViewController.h"
#import "Animal.h"
#import <objc/runtime.h>
#import "UIAlertView+Block.h"
#import "UIButton+Block.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //runtime 获取私有变量
    Animal *animal = [Animal new];
    [animal initWithPrivateVar:@"hello world"];
    animal.age = 10;
    animal.name = @"hello";
    animal.gender = @"world";
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [filePath stringByAppendingPathComponent:@"archivea.plist"];
    
//    NSMutableData *data = [NSMutableData data];
//    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
//    [archiver encodeObject:animal forKey:@"animal"];
//    [data writeToFile:filePath atomically:true];
//    NSLog(@"filePath = %@",filePath);
//    NSLog(@"data = %@",data);
//    NSData *dataRead = [NSData dataWithContentsOfFile:filePath];
//    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:dataRead
//                                     ];
//    Animal *deAnimal = [unarchiver decodeObjectForKey:@"animal1"];
//    NSLog(@"deAnimal:%@",deAnimal);
    BOOL success = [NSKeyedArchiver archiveRootObject:animal toFile:fileName];
    NSLog(@"success: %d",success);
    Animal *deAnimal = [NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
    NSLog(@"deAnimal: %@",deAnimal);
    //第一个参数是哪个类  第二个参数是 此类中的那个变量 加 _
    Ivar ivar = class_getInstanceVariable([Animal class], "_privateVar");
    NSString *str1 = object_getIvar(animal, ivar);
    NSLog(@"Str1: %@",str1);
    object_setIvar(animal, ivar, @"world hello");
    NSString *str2 = object_getIvar(animal, ivar);
    NSLog(@"Str2: %@",str2);
    //[self getInstanceMethodList:animal];
   // [self exchangeMethod:animal];
    NSLog(@"\n\n\n\n");
    [self getIvarList:animal];
    [self getPropertyList:animal];
    [self createBtn];
}

- (void)getInstanceMethodList:(id)objc {
    unsigned int count;
    Method *methods = class_copyMethodList([objc class], &count);
    for (int i = 0; i < count; i++) {
        SEL name = method_getName(methods[i]);
        NSLog(@"实例方法名:%@",NSStringFromSelector(name));
    }
    free(methods);
}

- (void)exchangeMethod:(id)objc {
    Method method1 = class_getInstanceMethod([self class], @selector(viewControllerLog));
    Method method2 = class_getInstanceMethod([objc class], @selector(logOneAnimal));
    method_exchangeImplementations(method1, method2);
    [self viewControllerLog];
}

- (void)viewControllerLog{
    NSLog(@"func viewController");
}

//获取类的属性
- (void)getPropertyList:(id)objc {
    //属性个数
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([objc class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *nameStr = [NSString stringWithUTF8String:property_getName(property)];
        NSLog(@"属性名:%@",nameStr);
    }
    free(properties);
    
}

//获取类的成员变量
- (void)getIvarList:(id)objc {
    unsigned int count;
    Ivar *ivarList = class_copyIvarList([objc class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivarList[i];
        NSString *nameStr = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSLog(@"成员变量:%@",nameStr);
    }
    free(ivarList);
    
}

//获取一个类的实例方法列表
- (void)getInstanceMethodLists:(id)objc {
    unsigned int count;
    Method *methods = class_copyMethodList([objc class], &count);
    for (int i = 0; i<count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *methodName = NSStringFromSelector(sel);
        NSLog(@"实例方法名: %@",methodName);
    }
    free(methods);
}

//获取类方法列表
- (void)getClassMethodLists:(id)objc {
    unsigned int count;
    Method *methods = class_copyMethodList(object_getClass([objc class]), &count);
    for (int i = 0; i<count; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        NSString *methodName = NSStringFromSelector(sel);
        NSLog(@"类方法名: %@",methodName);
    }
    free(methods);
}

//给一个类添加属性
static char weightProperty;
- (void)addWeight:(NSString *)weight forClass:(id)objc{
    objc_setAssociatedObject([objc class], &weightProperty, weight, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)getWeightFromObjc:(id)objc {
   return objc_getAssociatedObject([objc class], &weightProperty);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    Animal *animal = [Animal new];
    [self addWeight:@"50kg" forClass:animal];
    double delayInSeconds = 1.0;
    __weak typeof(self)weakSelf = self;
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        NSString *weight = [weakSelf getWeightFromObjc:animal];
        NSLog(@"体重:   %@",weight);
        [self createAlert];
    });
}

//UIAlertview 关联对象Block
- (void)createAlert {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"alert" message:@"hhhhhhh" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    
    //[alert show];
    //其实不用写 cancel 不会执行
    [alert showWithBlock:^(NSInteger buttonIndex) {
        NSLog(@"alert ok:%d",buttonIndex);
    } cancel:^{
        NSLog(@"cancel click");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //buttonIndex 0  取消  1 确定
    NSLog(@"alert ok");
}

//点击取消不执行 此代理方法所以 加的cancel没有用
- (void)alertViewCancel:(UIAlertView *)alertView{
    NSLog(@"cancel click");
}

//UIbutton关联对象block
- (void)createBtn {
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 30)];
    [btn setTitle:@"点击事件" forState: UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState: UIControlStateNormal];
    [self.view addSubview:btn];
    [btn handleWithBlock:^{
        NSLog(@"btn click action");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end


















