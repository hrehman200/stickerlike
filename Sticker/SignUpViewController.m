//
//  SignUpViewController.m
//  Sticker
//
//  Created by Trident Technolabs on 06/12/18.
//  Copyright © 2018 stickerlike. All rights reserved.
//

#import "SignUpViewController.h"
#import "LoginViewController.h"
#import "AFNetworking.h"
#import "MainViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.UserRegex.hidden = YES;
    self.EmailRegex.hidden = YES;
    self.PasswordRegex.hidden = YES;
    self.EmailTextField.delegate = self;
    self.PasswordTextField.delegate = self;
    self.userTextField.delegate = self;
    
    
    self.signInOutlet.layer.cornerRadius = 4.0;
    self.signInOutlet.layer.masksToBounds = YES;
    
    self.signUpOutlet.layer.cornerRadius = 4.0;
    self.signUpOutlet.layer.masksToBounds = YES;
    [NSUserDefaults.standardUserDefaults setObject:@"no" forKey:@"login"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SignInAction:(UIButton *)sender {
    NSLog(@"signIn");
    LoginViewController *ev = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:ev animated:false completion:nil];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField canResignFirstResponder])
    {
        [textField resignFirstResponder];
    }
    return YES;
}
- (IBAction)SignUpAction:(UIButton *)sender {
    NSLog(@"signUp");
    NSString *emailString = self.EmailTextField.text;
    NSString *passwordString = self.PasswordTextField.text;
    NSString *userString = self.userTextField.text;
   
    if([userString  isEqual: @""])
    {
        self.UserRegex.hidden = NO;
        self.UserRegex.text = @"user name is required";
    } else if([emailString  isEqual: @""])
    {
        self.EmailRegex.hidden = NO;
        self.EmailRegex.text = @"email is required.";
    } else if([passwordString  isEqual: @""])
    {
        self.PasswordRegex.hidden = NO;
        self.PasswordRegex.text = @"password is required";
    } else
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        if ([emailTest evaluateWithObject:_EmailTextField.text] == NO) {
            self.EmailRegex.hidden = NO;
            self.EmailRegex.text = @"please enter a valid email.";
        } else {
            self.EmailRegex.hidden = YES;
            self.PasswordRegex.hidden = YES;
            self.UserRegex.hidden = YES;
        
        // LoginApi Call:-
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
        
        NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
        
        [dictdata setValue:_EmailTextField.text forKey:@"email"];
        [dictdata setValue:_PasswordTextField.text forKey:@"password"];
        [dictdata setValue:_userTextField.text forKey:@"username"];
        NSLog(@"%@", dictdata);
        [manager GET:@"http://magicalxyz.com/sticker/backend/web/index.php?r=api/register" parameters:dictdata progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             NSMutableDictionary *dictionary;
             dictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                          options:kNilOptions
                                                            error:nil];
             NSLog(@"%@", dictionary);
             if ([dictionary[@"status"]  isEqual: @"1"])
             {
                 UIAlertController * alert = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:@"User Logged in Succesfully."
                                              preferredStyle:UIAlertControllerStyleAlert];
                 
                 
                 
                 UIAlertAction* OkButton = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                                MainViewController *ev = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
                                                [self presentViewController:ev animated:false completion:nil];
                                            }];
                 
                 [alert addAction:OkButton];
                 [self presentViewController:alert animated:YES completion:nil];
               [NSUserDefaults.standardUserDefaults setObject:@"yes" forKey:@"login"];
                 
             }
             else if([dictionary[@"message"]  isEqual: @"Email already exists."]) {
                 UIAlertController * alert = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:@"Email already exists."
                                              preferredStyle:UIAlertControllerStyleAlert];
                 
                 
                 
                 UIAlertAction* OkButton = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                            }];
                 
                 [alert addAction:OkButton];
                 [self presentViewController:alert animated:YES completion:nil];
             }
             else {
                 UIAlertController * alert = [UIAlertController
                                              alertControllerWithTitle:@"Alert"
                                              message:@"Something Went Wrong."
                                              preferredStyle:UIAlertControllerStyleAlert];
                 
                 
                 
                 UIAlertAction* OkButton = [UIAlertAction
                                            actionWithTitle:@"Ok"
                                            style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * action) {
                                            }];
                 
                 [alert addAction:OkButton];
                 [self presentViewController:alert animated:YES completion:nil];
                 
             }
             
         }
              failure:^(NSURLSessionTask *operation, NSError *error)
         {
             NSLog(@"Error: %@", error);
         }];
        }
    }
    
}

@end
