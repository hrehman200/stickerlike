//
//  EditViewController.h
//  Sticker
//
//  Created by starlike on 2018/11/4.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController
- (IBAction)cancel:(id)sender;
@property UIImage *editimage;

@property (weak, nonatomic) IBOutlet UIImageView *editimageview;
- (IBAction)filter:(id)sender;
- (IBAction)stickerclick:(id)sender;
- (IBAction)undo:(id)sender;
- (IBAction)share:(id)sender;

@end
