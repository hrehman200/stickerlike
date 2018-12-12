//
//  LoginViewController.h
//  Sticker
//
//  Created by Trident Technolabs on 06/12/18.
//  Copyright © 2018 stickerlike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *Email;
@property (weak, nonatomic) IBOutlet UITextField *EmailTextField;
@property (weak, nonatomic) IBOutlet UILabel *EmailRegex;
@property (weak, nonatomic) IBOutlet UILabel *Password;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
@property (weak, nonatomic) IBOutlet UILabel *PasswordRegex;
@property (weak, nonatomic) IBOutlet UIButton *signInOutlet;
@property (weak, nonatomic) IBOutlet UIButton *signUpOutlet;

- (IBAction)SignInAction:(UIButton *)sender;
- (IBAction)SignUpAction:(UIButton *)sender;

@end
