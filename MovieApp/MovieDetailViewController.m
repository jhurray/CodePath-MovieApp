//
//  MovieDetailViewController.m
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/23/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+FadeUtils.h"

@interface MovieDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.model.title;
    self.titleLabel.text = self.model.title;
    self.detailLabel.text = self.model.movieDescription;
    [self.imageView setAndFadeImageWithURL:self.model.posterURL];
    
    [self resizeLabel:self.detailLabel];
    
    CGFloat xMargin = 48;
    CGFloat cardHeight = CGRectGetMaxY(self.detailLabel.frame) + 48;
    CGFloat bottomPadding = 64;
    CGFloat cardOffset = cardHeight * 0.75;
    self.scrollView.frame = CGRectMake(xMargin, // x
                                       CGRectGetHeight(self.view.bounds) - cardHeight - bottomPadding, // y
                                       CGRectGetWidth(self.view.bounds) - 2 * xMargin, // width
                                       cardHeight); // height
    
    self.cardView.frame = CGRectMake(0, cardOffset, CGRectGetWidth(self.scrollView.bounds), cardHeight);

    // content height is the height of the card plus the offset we want
    CGFloat contentHeight =  cardHeight + cardOffset;
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width, contentHeight);
}


- (void)resizeLabel:(UILabel*)label
{
    [label sizeToFit];
}

@end
