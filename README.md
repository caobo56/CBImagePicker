# CBImagePicker 
图片选择器
可以选择相册，也可以直接拍照

# 使用方法：
				#import "ABImagePicker.h"

				-(void)startPicker{
    				ABImagePicker * picker = [ABImagePicker shared];
				    [picker startWithVC:self];
				    [picker setPickerCompletion:^(NSError *error, UIImage *image) {
				        if (!error) {
				        	//图片可用
				        	
				        }else{
				            //error 中会有错误的说明
 				       }
				    }];
				}


# 接口列表：
				/**
 				选择器的回调

 				@param error error
 				@param image 图片
 				*/
				typedef void(^PickerCompletion)(NSError* error,UIImage* image);

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
