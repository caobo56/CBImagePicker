//
//  ABImagePicker.h
//  ABCreditApp
//
//  Created by caobo56 on 2017/3/13.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^PickerCompletion)(NSError* error,UIImage* image);


@interface ABImagePicker : NSObject

+(instancetype)shared;

-(void)startWithVC:(UIViewController *)vc;

-(void)setPickerCompletion:(PickerCompletion)comp;

@end
