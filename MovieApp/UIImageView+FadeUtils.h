//
//  UIImageView+FadeUtils.h
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/26/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>

// Steps to make a category:
// 1) Create new file
// 2) Choose `Objective-C File`
// 3) Choose the class you want to extend
// 4) Categorize the extension (in this case `FadeUtils`)

@interface UIImageView (FadeUtils)

- (void)setAndFadeImageWithURL:(NSURL *)URL;

@end
