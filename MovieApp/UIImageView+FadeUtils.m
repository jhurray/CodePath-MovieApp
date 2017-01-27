//
//  UIImageView+FadeUtils.m
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/26/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "UIImageView+FadeUtils.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation UIImageView (FadeUtils)

- (void)setAndFadeImageWithURL:(NSURL *)URL
{
    __weak __typeof(self) weakSelf = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull image) {
        
        if (response != nil) {
            NSLog(@"Image was NOT cached, fade in image");
            weakSelf.alpha = 0.0;
            weakSelf.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.alpha = 1;
            }];
        } else {
            NSLog(@"Image was cached so just update the image");
            weakSelf.image = image;
        }
        
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        // on failure
    }];
}

@end
