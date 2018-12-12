//
//  MainViewController.h
//  Sticker
//
//  Created by starlike on 2018/11/4.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
- (IBAction)openpic:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *takepic;
- (IBAction)takepic:(id)sender;

@end
