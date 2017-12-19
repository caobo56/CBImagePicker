//
//  ABImagePicker.m
//  ABCreditApp
//
//  Created by caobo56 on 2017/3/13.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "ABImagePicker.h"
#import <MobileCoreServices/MobileCoreServices.h>

const float kScaleHeadImageHeights = 500.0f;

@interface ABImagePicker()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(nonatomic,weak)UIViewController * vc;
@property(nonatomic,copy)PickerCompletion comp;
@end

static ABImagePicker *imagePicker = nil;


@implementation ABImagePicker

+(instancetype)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^ {
        if (!imagePicker) {
            imagePicker = [ABImagePicker new];
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
         UIImage* image = info[UIImagePickerControllerEditedImage];
         if (image.size.height/image.size.width !=1  )
         {
             image = [weakSelf imageScaleAspectFit:image toSize:CGSizeMake(kScaleHeadImageHeights, kScaleHeadImageHeights)];
         }
         _comp(nil,image);
     }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{    
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
