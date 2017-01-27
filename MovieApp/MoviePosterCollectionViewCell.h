//
//  MoviePosterCollectionViewCell.h
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/26/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovieModel.h"

@interface MoviePosterCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) MovieModel *model;

- (void)reloadData;

@end
