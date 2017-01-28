//
//  ViewController.m
//  MovieApp
//
//  Created by  Jeffrey Hurray on 1/23/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieTableViewCell.h"
#import "MovieModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MovieDetailViewController.h"
#import "MoviePosterCollectionViewCell.h"
#import "MovieFetcher.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface MovieListViewController () <UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UILabel *errorView;
@property (nonatomic, weak) UIRefreshControl *collectionRefreshControl;
@property (nonatomic, weak) UIRefreshControl *tableRefreshControl;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray<MovieModel *> *movies;
@property (nonatomic, assign) MovieListType type;

@end

@implementation MovieListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.tableView.dataSource = self;
    
    static NSDictionary<NSString *, NSNumber *> *restorationIdentifierToTypeMapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        restorationIdentifierToTypeMapping = @{
                                              @"now_playing": @(MovieListTypeNowPlaying),
                                              @"top_rated": @(MovieListTypeTopRated),
                                              };
    });
    self.type = restorationIdentifierToTypeMapping[self.restorationIdentifier].integerValue;
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"List", @"Grid"]];
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    self.segmentedControl = segmentedControl;
    
    UILabel *errorView = [[UILabel alloc] init];
    errorView.text = @"Error: Something went wrong.";
    errorView.font = [UIFont systemFontOfSize:22];
    errorView.backgroundColor = [UIColor redColor];
    errorView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 80);
    [errorView setTextColor:[UIColor whiteColor]];
    errorView.hidden = YES;
    [self.view addSubview:errorView];
    self.errorView = errorView;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat screenWidth = CGRectGetWidth(self.view.bounds);
    CGFloat itemHeight = 150;
    CGFloat itemWidth = screenWidth / 3;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [collectionView registerClass:[MoviePosterCollectionViewCell class] forCellWithReuseIdentifier:@"MoviePosterCollectionViewCell"];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    collectionView.hidden = YES;
    self.collectionView = collectionView;
    
    // This is a block. Think of it as a scoped function within this method
    // This block will create a refresh control, add it to the scroll view (table or collection), and return it
    // This promotes code reusability. You could also accomplish this in a helper method
    UIRefreshControl *(^setupRefreshControlWithScrolView)(UIScrollView *) = ^UIRefreshControl *(UIScrollView *scrollView) {
        UIRefreshControl *control = [[UIRefreshControl alloc] init];
        [scrollView addSubview:control];
        [control addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
        return control;
    };
    self.collectionRefreshControl = setupRefreshControlWithScrolView(self.collectionView);
    self.tableRefreshControl = setupRefreshControlWithScrolView(self.tableView);
    
    [self fetchMovies];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.tableView.frame = self.view.bounds;
}


- (void)showErrorView
{
    self.errorView.alpha = 0;
    self.errorView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.alpha = 1.0;
    }];
}


- (void)hideErrorView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.errorView.alpha = 0;
    } completion:^(BOOL finished) {
        self.errorView.hidden = YES;
    }];
}


- (void)segmentedControlChanged:(UISegmentedControl *)control
{
    BOOL showTable = control.selectedSegmentIndex == 0;
    self.tableView.hidden = !showTable;
    self.collectionView.hidden = showTable;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // This will only be triggered from the tableView segue
    UITableViewCell *cell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    MovieDetailViewController *detailViewController = segue.destinationViewController;
    detailViewController.model = model;
}


- (void)fetchMovies
{
    static MovieFetcher *fetcher;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fetcher = [[MovieFetcher alloc] init];
    });
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [fetcher fetchMoviesWithType:self.type completion:^(NSArray<MovieModel *> *models, NSError *error) {
        
        self.movies = models;
        switch (self.segmentedControl.selectedSegmentIndex) {
            case 0:
                [self.tableView reloadData];
                [self.tableRefreshControl endRefreshing];
                break;
            case 1:
                [self.collectionView reloadData];
                [self.collectionRefreshControl endRefreshing];
                break;
            default:
                break;
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (error == nil) {
            [self hideErrorView];
        }
        else {
            [self showErrorView];
        }
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellIdentifier = @"MovieTableViewCell";
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.row];
    cell.titleLabel.text = model.title;
    cell.textView.text = model.movieDescription;
    cell.posterView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.posterView setImageWithURL:model.posterURL];
    
    return cell;
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.movies.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MoviePosterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MoviePosterCollectionViewCell" forIndexPath:indexPath];
    MovieModel *model = [self.movies objectAtIndex:indexPath.item];
    cell.model = model;
    [cell reloadData];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // A programatic way to show a view controller (from the collectionView)
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MovieDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"MovieDetailViewController"];
    detailViewController.model = self.movies[indexPath.item];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
