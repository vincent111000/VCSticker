//
//  OCDemoViewController.m
//  VCStickerDemo
//
//  Created by Vincent on 2021/2/24.
//  Copyright © 2021 Vincent. All rights reserved.
//

#import "OCDemoViewController.h"
#import "VCStickerDemo-Swift.h"

@interface OCDemoViewController ()
@property(nonatomic, strong) VCBaseSticker *mSticker;
@end

@implementation OCDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)addLabelSticker:(id)sender {
    VCLabelSticker *labelSticker = [[VCLabelSticker alloc] initWithCenter:self.view.center];
    [self.view addSubview:labelSticker];
    
    labelSticker.textColor = [UIColor redColor];
    labelSticker.borderColor = [UIColor redColor];
    labelSticker.text = @"999";
    labelSticker.closeBtnEnable  = YES;                // 是否显示关闭按钮
    labelSticker.resizeBtnEnable = YES;                // 是否显示缩放按钮
    labelSticker.restrictionEnable = YES;              // 开启边缘限制
    labelSticker.onBeginEditing = ^{
        if (labelSticker != self.mSticker) {
            [self.mSticker finishEditing];
            self->_mSticker = labelSticker;
        }
    };
}

- (IBAction)addImageSticker:(id)sender {
    VCImageSticker *imageSticker = [[VCImageSticker alloc] initWithFrame:CGRectMake(20, 120, 200, 200)];
    imageSticker.imageView.image = [UIImage imageNamed:@"test"];
    imageSticker.borderColor = [UIColor blueColor];
    [self.view addSubview:imageSticker];
    
    imageSticker.onBeginEditing = ^{
        if (imageSticker != self.mSticker) {
            [self.mSticker finishEditing];
            self->_mSticker = imageSticker;
        }
    };
}


@end
