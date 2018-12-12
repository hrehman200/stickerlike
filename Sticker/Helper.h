//
//  Helper.h
//  Sticker
//
//  Created by starlike on 2018/11/11.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Helper : NSObject

+ (CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview;
+ (void)setSticker:(NSInteger) n stickerType:(int) type;
+ (NSInteger)getSticker:(int) type;
+ (void)setCoin:(NSInteger) num;
+ (NSInteger)getCoin;
+ (void)setEmail:(NSString*) _email;
+ (NSString*)getEmail;


@end
