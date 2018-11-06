//
//  CBImagePicker.m
//  ABCreditApp
//
//  Created by caobo56 on 2017/3/13.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "CBImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

const float kScaleHeadImageHeights = 500.0f;

@interface CBImagePicker()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,weak)UIViewController * vc;
@property(nonatomic,copy)PickerCompletion comp;
@end

static CBImagePicker *imagePicker = nil;


@implementation CBImagePicker

+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        if (!imagePicker) {
            imagePicker = [CBImagePicker new];
        }
    });
    return imagePicker;
}

-(void)startWithVC:(UIViewController *)vc{
    _vc = vc;

    UIAlertController *alertController = [[UIAlertController alloc] init];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    [self p_takePhotoFromCamera];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {
                                    [self p_takePhotoFromPhotoLibrary];
                                }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action)
                                {
                                }]];
    
    [_vc presentViewController:alertController animated:YES completion:nil];
}

-(void)setPickerCompletion:(PickerCompletion)comp{
    _comp = comp;
}


- (void)p_takePhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.title  = @"拍照";
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        [_vc presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)p_takePhotoFromPhotoLibrary
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePicker = [UIImagePickerController new];
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.title  = @"选择照片";
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        [_vc presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^()
     {
         //此处选择为原始图片，若需要裁剪，可用 UIImagePickerControllerEditedImage
         UIImage* image = info[UIImagePickerControllerOriginalImage];
         dispatch_async(dispatch_get_main_queue(), ^{
             if (_comp) {
                 _comp(weakSelf,nil,image);
             }
         });
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_comp) {
            NSString * description = @"";
            if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                description = @"用户已取消选择照片！";
            }else{
                description = @"用户已取消拍照！";
            }
            NSError * error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:1 userInfo:@{@"description":description}];
            _comp(weakSelf,error,nil);
        }
    });
    [picker dismissViewControllerAnimated:YES completion:nil];
}




- (UIImage*)imageScaleAspectFit:(UIImage *)image toSize:(CGSize)se
{
    UIGraphicsBeginImageContextWithOptions(se, YES, 1.0);
    
    CGSize imgSe=image.size;
    
    if (imgSe.width/se.width<imgSe.height/se.height) {
        
        [image drawInRect:CGRectMake((se.width-se.height*imgSe.width/imgSe.height)*0.5f,
                                     0.0f,
                                     se.height*imgSe.width/imgSe.height,
                                     se.height)];
    }else{
        [image drawInRect:CGRectMake(0,
                                     (se.height-se.width*imgSe.height/imgSe.width)*0.5f,
                                     se.width,
                                     se.width*imgSe.height/imgSe.width)];
    }
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
