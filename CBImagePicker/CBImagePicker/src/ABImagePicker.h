//
//  ABImagePicker.h
//  ABCreditApp
//
//  Created by caobo56 on 2017/3/13.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class ABImagePicker;
/**
 选择器的回调

 @param error error
 @param image 图片
 */
typedef void(^PickerCompletion)(ABImagePicker * picker,NSError* error,UIImage* image);

@interface ABImagePicker : NSObject


/**
 单例模式，可以直接获取对象

 @return ABImagePicker
 */
+(instancetype)shared;


/**
 设置当前选择器的VC

 @param vc 当前选择器的VC
 */
-(void)startWithVC:(UIViewController *)vc;


/**
 选择器的回调

 @param comp 回调中有图片
 */
-(void)setPickerCompletion:(PickerCompletion)comp;

@end
