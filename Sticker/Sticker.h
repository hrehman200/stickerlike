//
//  Sticker.h
//  ElMostacho
//
//  Created by allzone alzone on 11/24/13.
//  Copyright (c) 2013 iBit Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sticker;

@protocol StickerDelegate <NSObject>

- (void)stickerisSelected:(Sticker*)sticker;

@end

//@interface Sticker : UIView<UIGestureRecognizerDelegate>
@interface Sticker : UIImageView<UIGestureRecognizerDelegate>
{
    UIPanGestureRecognizer *panRecognizer;
    UIPinchGestureRecognizer *pinchRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
    
//    UIImageView *imageSticker;
    
    BOOL isSelected;
    
    id<StickerDelegate> delegate;
    NSString *stickerName;
}

@property (nonatomic, strong) id<StickerDelegate> delegate;
@property (nonatomic, strong) NSString *stickerName;
@property (nonatomic) BOOL isSelected;

- (void)setBorder:(BOOL)border;

- (void)removeAllGestureRecognizersFromView;
- (void)setStickerImage:(UIImage*)image;
- (UIImage*)getStickerImage;
@end
