//
//  MovieTableViewCell.h
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/23/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
