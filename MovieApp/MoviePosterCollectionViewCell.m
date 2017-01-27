//
//  MoviePosterCollectionViewCell.m
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/26/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "MoviePosterCollectionViewCell.h"
#import "UIImageView+FadeUtils.h"

@interface MoviePosterCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MoviePosterCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.imageView];
        //self.imageView = imageView;
    }
    return self;
}


- (void)reloadData
{
    // assumes model is set
    [self.imageView setAndFadeImageWithURL:self.model.posterURL];
    // Makes sure `layoutSubviews` is called
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // image view is same size as cell
    self.imageView.frame = self.contentView.bounds;
}


@end
