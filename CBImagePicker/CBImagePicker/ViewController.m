//
//  ViewController.m
//  CBImagePicker
//
//  Created by caobo56 on 2017/12/19.
//  Copyright © 2017年 caobo56. All rights reserved.
//

#import "ViewController.h"
#import "ABImagePicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickBtnPress:(id)sender {
    [self startPicker];
}


-(void)startPicker{
    ABImagePicker * picker = [ABImagePicker shared];
    [picker startWithVC:self];
    [picker setPickerCompletion:^(ABImagePicker * picker, NSError *error, UIImage *image) {
        if (!error) {
            
        }else{

        }
    }];
}


@end
