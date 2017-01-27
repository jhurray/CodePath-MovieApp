//
//  MovieFetcher.h
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/26/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovieModel.h"

typedef NS_ENUM(NSInteger, MovieListType) {
    MovieListTypeNowPlaying,
    MovieListTypeTopRated,
};

@interface MovieFetcher : NSObject

- (void)fetchMoviesWithType:(MovieListType)type completion:(void(^)(NSArray<MovieModel *> *models, NSError *error))completion;

@end
