//
//  Sticker.m
//  ElMostacho
//
//  Created by allzone alzone on 11/24/13.
//  Copyright (c) 2013 iBit Solutions. All rights reserved.
//

#import "Sticker.h"

@implementation Sticker
@synthesize isSelected, delegate, stickerName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.userInteractionEnabled = YES;

        self.contentMode = UIViewContentModeScaleAspectFit;
        
        //TODO: change!
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void)setBorder:(BOOL)border
{
    if (border)
        self.layer.borderWidth = 2.0;
    else
        self.layer.borderWidth = 0.0;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#pragma mark - Set Gesture Recongnizer

- (void)setStickerImage:(UIImage *)image
{
    self.image = image;
}

- (UIImage*)getStickerImage
{
    return [self image];
}

- (void)removeAllGestureRecognizersFromView
{
    [self removeGestureRecognizer:panRecognizer];
    [self removeGestureRecognizer:pinchRecognizer];
    [self removeGestureRecognizer:rotationRecognizer];
}

#pragma mark - Gesture Recognizers

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([[event allTouches] count] == 1)
        if ([self.delegate respondsToSelector:@selector(stickerisSelected:)])
        {
            [[self superview] bringSubviewToFront:self];
            [self.delegate stickerisSelected:self];
        }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
