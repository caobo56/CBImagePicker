### CBImagePicker 
图片选择器
可以选择相册，也可以直接拍照

### 使用方法：
使用pod 安装，也可以直接下载源码拖进工程
```
    pod 'CBImagePicker'
```

### 设置权限申请
在Info.plist 文件中添加下面两项权限申请。
###### string 为项目的权限申请描述，写的不好，会被审核打回来的
```
<key>NSPhotoLibraryUsageDescription</key>
<string>相册权限</string>
<key>NSCameraUsageDescription</key>
<string>相机权限</string>
```

### 导入头文件
```
#import "ABImagePicker.h"
```
### 初始化ImagePicker
```
-(void)startPicker{
    ABImagePicker * picker = [ABImagePicker shared];
    [picker startWithVC:self];
    [picker setPickerCompletion:^(ABImagePicker * picker, NSError *error, UIImage *image) {
        if (!error) {
            //图片可用
            
        }else{
            //error 中会有错误的说明
       }
    }];
}
```

### 接口列表：
```

@class ABImagePicker;
/**
 选择器的回调

 @param picker 当前picker对象
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
```
