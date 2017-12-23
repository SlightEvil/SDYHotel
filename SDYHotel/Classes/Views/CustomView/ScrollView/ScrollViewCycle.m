//
//  ScrollViewCycle.m
//  SDYHotel
//
//  Created by admin on 2017/12/22.
//  Copyright © 2017年 SanDaoYi. All rights reserved.
//

#import "ScrollViewCycle.h"

@interface ScrollViewCycle ()<UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) NSTimer *timer;


@end


@implementation ScrollViewCycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.scrollView];
        self.pageControl.center = CGPointMake(self.scrollView.bounds.size.width/2, self.scrollView.bounds.size.height - 20);
        [self insertSubview:self.pageControl aboveSubview:self.scrollView];
    }
    return self;
}

- (void)startAnimation
{
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopAnimation
{
    [self.timer setFireDate:[NSDate distantFuture]];
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.pageControl.currentPage = self.scrollView.contentOffset.x/scrollView.bounds.size.width;
}

#pragma mark - Private method

- (void)scrollViewStartScroll
{
    if (self.scrollView.contentOffset.x < self.bounds.size.width * (self.dataSourceImage.count - 1)) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + self.bounds.size.width, 0) animated:YES];
    } else {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}


#pragma mark - Getter and Setter

- (void)setDataSourceImage:(NSMutableArray *)dataSourceImage
{
    _dataSourceImage = dataSourceImage;
    
    self.pageControl.numberOfPages = _dataSourceImage.count;

    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    self.scrollView.contentSize = CGSizeMake(width * _dataSourceImage.count, 0);
    
    [dataSourceImage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(width *idx, 0, width, height)];
        imageView.image = [self imageWithName:obj imageSize:CGSizeMake(width, height)];
        [self.scrollView addSubview:imageView];
    }];
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}


- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.clipsToBounds = YES;
//        _scrollView.scrollEnabled = YES;
        _scrollView.directionalLockEnabled = YES;//锁定滑动的方向
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
//        _scrollView.minimumZoomScale = 0.5;
//        _scrollView.maximumZoomScale = 1.5;
    }
    return _scrollView;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(scrollViewStartScroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return _timer;
}

- (UIImage *)imageWithName:(NSString *)imageName imageSize:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:imageName];
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *compleImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compleImage;
}

- (void)dealloc
{
    [self.timer invalidate];
    
}


@end
