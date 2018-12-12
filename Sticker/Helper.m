//
//  Helper.m
//  Sticker
//
//  Created by starlike on 2018/11/11.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import "Helper.h"

@implementation Helper


+ (CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview
{
    
    
    float newwidth;
    float newheight;
    
    UIImage *image=imgview.image;
    
    if (image.size.height>=image.size.width){
        newheight=imgview.frame.size.height;
        newwidth=(image.size.width/image.size.height)*newheight;
        
        if(newwidth>imgview.frame.size.width){
            float diff=imgview.frame.size.width-newwidth;
            newheight=newheight+diff/newheight*newheight;
            newwidth=imgview.frame.size.width;
        }
        
    }
    else{
        newwidth=imgview.frame.size.width;
        newheight=(image.size.height/image.size.width)*newwidth;
        
        if(newheight>imgview.frame.size.height){
            float diff=imgview.frame.size.height-newheight;
            newwidth=newwidth+diff/newwidth*newwidth;
            newheight=imgview.frame.size.height;
        }
    }
    
    
    
    //adapt UIImageView size to image size
    //imgview.frame=CGRectMake(imgview.frame.origin.x+(imgview.frame.size.width-newwidth)/2,imgview.frame.origin.y+(imgview.frame.size.height-newheight)/2,newwidth,newheight);
    
    return CGSizeMake((int)newwidth, (int)newheight);
    
}

+ (void)setSticker:(NSInteger) n stickerType:(int) type
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *stickertype = [NSArray arrayWithObjects:@"sticker0", @"sticker1", @"sticker2", @"sticker3", nil];
    [defaults setInteger:n forKey:[stickertype objectAtIndex:type]];
    [defaults synchronize]; //立即同步进行保存
}

+ (NSInteger)getSticker:(int) type
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *stickertype = [NSArray arrayWithObjects:@"sticker0", @"sticker1", @"sticker2", @"sticker3", nil];
    return [defaults integerForKey:[stickertype objectAtIndex:type]];
}

+ (void)setCoin:(NSInteger) num
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:num forKey:@"coin"];
    [defaults synchronize];
}

+ (NSInteger)getCoin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:@"coin"];
}

+ (void)setEmail:(NSString*) _email
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_email forKey:@"email"];
    [defaults synchronize];
}

+ (NSString*)getEmail
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults stringForKey:@"email"];
}

@end
