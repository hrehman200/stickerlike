//
//  AddStickerViewController.m
//  Sticker
//
//  Created by slow on 2018/12/2.
//   © 2018年 stickerlike. All rights reserved.
//

#import "AddStickerViewController.h"
#import "Helper.h"

#define HOST @"http://magicalxyz.com/pay/" //@"http://localhost/magicalxyz_pay/"

@interface AddStickerViewController ()

@end

@implementation AddStickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btn1:(id)sender {
   /* int coin = [Helper getCoin] + 500;
    NSLog(@"con %d", coin);
    [Helper setCoin:coin];*/
    coinsToAdd = 500;
    [self showPayMethodAlert];
}

- (IBAction)btn2:(id)sender {
    /*int coin = [Helper getCoin] + 1500;
    NSLog(@"con %d", coin);
    [Helper setCoin:coin];*/
    coinsToAdd = 1500;
     [self showPayMethodAlert];
}

- (IBAction)btn3:(id)sender {
    /*int coin = [Helper getCoin] + 4000;
    NSLog(@"con %d", coin);
    [Helper setCoin:coin];*/
    coinsToAdd = 4000;
     [self showPayMethodAlert];
}

- (IBAction)btn4:(id)sender {
    /*int coin = [Helper getCoin] + 12000;
    NSLog(@"con %d", coin);
    [Helper setCoin:coin];*/
    coinsToAdd = 12000;
     [self showPayMethodAlert];
}

- (IBAction)btn5:(id)sender {
    /*int coin = [Helper getCoin] + 55000;
    NSLog(@"con %d", coin);
    [Helper setCoin:coin];*/
    coinsToAdd = 55000;
    [self showPayMethodAlert];
}


-(void) showPayMethodAlert{
    UIAlertView*  alert = [[UIAlertView alloc]initWithTitle:@"Choose a method to pay" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Paypal",@"Stripe", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Paypal"]) {
        [self showPaypal];
    }
    if ([title isEqualToString:@"Stripe"]) {
        [self showStripe];
    }
}

-(void) showPaypal{
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:
                                  [NSString stringWithFormat:@"%@mobile_stripe.php?user_email=%@",@"http://localhost/magicalxyz_pay/", [Helper getEmail]  ]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    [_webView loadRequest:request];
    
}

-(void) showStripe{
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:_webView];
    _webView.delegate = self;
    
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:
                                  [NSString stringWithFormat:@"%@mobile_stripe.php?user_email=%@&c=%d", HOST, [Helper getEmail], coinsToAdd  ]] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
    
    [_webView loadRequest:request];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] isEqualToString:@"https://www.yahoo.com/"]) {
        [_webView removeFromSuperview];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success"
                                                                       message:@"Coins will be added in a few minutes."
                                                                preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    
    } else if ([[request.URL absoluteString] isEqualToString:@"https://www.google.com/"]) {
        [_webView removeFromSuperview];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:@"Some error occurred in making the payment."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

@end
