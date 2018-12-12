//
//  MainViewController.m
//  Sticker
//
//  Created by starlike on 2018/11/4.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import "MainViewController.h"
#import "EditViewController.h"

@interface MainViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.view.bounds];
    imageView.image=[UIImage imageNamed:@"splash-background"];
    [self.view insertSubview:imageView atIndex:0];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (image == NULL) {
        NSLog(@"image picker fail");
        return;
    }
    
    EditViewController *ev = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    ev.editimage = image;
    //[self.navigationController pre:ev animated:nil];
    [self presentViewController:ev animated:false completion:nil];
}

- (IBAction)openpic:(id)sender {
    UIImagePickerController *pickControll = [[UIImagePickerController alloc] init];
    pickControll.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickControll.delegate = self;
    //pickControll.allowsEditing = YES;
    [self presentViewController:pickControll animated:nil completion:nil];
}

- (IBAction)takepic:(id)sender {
    UIImagePickerController *pickControll = [[UIImagePickerController alloc]init];
    pickControll.sourceType = UIImagePickerControllerSourceTypeCamera;
    //pickControll.allowsEditing = YES;
    pickControll.delegate = self;
    [self presentViewController:pickControll animated:YES completion:nil];
}
@end
