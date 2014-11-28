//
//  WBMainViewController.m
//  WristBand
//
//  Created by zhuzhi on 14/11/1.
//  Copyright (c) 2014年 WB. All rights reserved.
//

#import "WBMainViewController.h"
#import "WBHitTestView.h"
#import "WBCollectionViewCell.h"
#import "WBSettingViewController.h"
#import "WBMainView.h"
#import "WBConnectDeviceView.h"
#import "WBMeasuringView.h"
#import "WBSleepInfo.h"
#import "WBSleepPoint.h"
#import "WBDataOperation.h"

static NSString *CollectionCellIdentifier = @"collectionCellIdentifier";

@interface WBMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,WBConnectDeviceViewDelegate,WBMainViewDelegate>

@property (nonatomic,strong)UINavigationBar *navigationBar;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic)BOOL scrollToRight;

@property (nonatomic,strong)NSArray *sleepInfos;

@property (nonatomic,strong)WBConnectDeviceView *connectDeviceView;
@property (nonatomic,strong)NSLayoutConstraint *topConstraint;
@property (nonatomic,strong)WBMeasuringView *measuringView;

@end

@implementation WBMainViewController

- (void)loadView {
    WBHitTestView *view = [[WBHitTestView alloc] init];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(215,222,223);
    _navigationBar = [[UINavigationBar alloc] init];
    [self.view addSubview:_navigationBar];
    [_navigationBar autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [_navigationBar autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_navigationBar autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_navigationBar autoSetDimension:ALDimensionHeight toSize:64.0f];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RGB(146,162,163);
    [_navigationBar addSubview:lineView];
    [lineView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(62.5f, 0.0f, 0.0f, 0.0f)];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    [_navigationBar pushNavigationItem:navigationItem animated:YES];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(userSettingClick) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0.0f, 0.0f, 25.0f, 25.0f)];
    navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(IPHONE_WIDTH, IPHONE_HEIGHT_WITHOUTTOPBAR);
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _collectionView.scrollsToTop = NO;
    _collectionView.backgroundColor = RGB(215,222,223);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [_collectionView registerClass:[WBCollectionViewCell class] forCellWithReuseIdentifier:CollectionCellIdentifier];
    [self.view addSubview:self.collectionView];
    
    [_collectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_navigationBar];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [_collectionView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    _connectDeviceView = [[WBConnectDeviceView alloc] init];
    _connectDeviceView.delegate = self;
    [_connectDeviceView.panGestureRecognizer addTarget:self action:@selector(panGestureRecognizer:)];
    [_connectDeviceView.startSleepingButton addTarget:self action:@selector(startSleepingClick) forControlEvents:UIControlEventTouchUpInside];
    [_connectDeviceView.cancelButton addTarget:self action:@selector(cancelConnectClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_connectDeviceView];
    _topConstraint = [_connectDeviceView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:IPHONE_HEIGHT - 43.0f];
    [_connectDeviceView autoSetDimension:ALDimensionHeight toSize:IPHONE_HEIGHT + 43.0f + 64.0f];
    [_connectDeviceView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    
    [self test];
    
}

- (void)test {
    [self initDummyData];
}

- (void)viewDidLayoutSubviews {
    if (!_scrollToRight) {
        [_collectionView setContentOffset:CGPointMake(self.sleepInfos.count * IPHONE_WIDTH, 0) animated:NO];
        _scrollToRight = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userSettingClick {
    WBSettingViewController *settingViewController = [[WBSettingViewController alloc] init];
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    navigationViewController.navigationBar.top += 20.0f;
    [self.containViewController addChildViewController:navigationViewController];
    [navigationViewController willMoveToParentViewController:self.containViewController];

    [self.containViewController transitionFromViewController:self toViewController:navigationViewController duration:0.55f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Sleep data

- (void)initDummyData {
	self.sleepInfos = [NSArray arrayWithArray:[[WBDataOperation shareInstance] querySleepData]];
    
//    NSMutableArray *mutableArr = [NSMutableArray array];
//    
//    for (int i = 0; i < 3; i++) {
//        WBSleepInfo *sleepInfo = [[WBSleepInfo alloc] init];
//        sleepInfo.time = [[NSDate date] timeIntervalSince1970];
//        
//        WBSleepScore *score = [[WBSleepScore alloc] init];
//        score.amountOfSleep = 68 + i * 18;
//        score.gotupFromBed = 10 + i * 1;
//        score.sleepVSAwake = -5 - i * 3;
//        score.wakingEvents = - i;
//        score.sleepLatency = -8 + i * 4;
//        score.snoring = - i;
//        sleepInfo.sleepScore = score;
//        
//        sleepInfo.improvementIdeas = [NSString stringWithFormat:@"%d Exercise regularly", i];
//        sleepInfo.improvementIdeasDetail = [NSString stringWithFormat:@"%d Aerobic exercise in the afternoon or at least 3 hours efore going to bed is good for sleep", i];
//        
//        sleepInfo.totalSleepTime = (4 + i) * 3600 + 47 * 60;
//        
//        NSMutableArray *array = [NSMutableArray array];
//        
//        NSMutableArray *inbedArray = [NSMutableArray array];
//        NSMutableArray *fallAsleepArray1 = [NSMutableArray array];
//        NSMutableArray *normalArray = [NSMutableArray array];
//        NSMutableArray *fallAsleepArray2 = [NSMutableArray array];
//        
//        NSDate *date = [NSDate dateWithTimeInterval:-28 * 3600 sinceDate:[NSDate date]];
//        for (int i = 0; i  < 15 * 60; i+=10) {
//            WBSleepPoint *sleepPoint = [[WBSleepPoint alloc] init];
//            sleepPoint.time = [[date dateByAddingTimeInterval:i * 60] timeIntervalSince1970];
//            if (i < 100) {
//                sleepPoint.state = WBSleepPointStateInbed;
//                [inbedArray addObject:sleepPoint];
//            } else if (i < 600) {
//                sleepPoint.state = WBSleepPointStateFallAsleep;
//                [fallAsleepArray1 addObject:sleepPoint];
//            } else if (i < 800){
//                sleepPoint.state = WBSleepPointStateNormal;
//                [normalArray addObject:sleepPoint];
//            } else {
//                sleepPoint.state = WBSleepPointStateFallAsleep;
//                [fallAsleepArray2 addObject:sleepPoint];
//            }
//            
//            sleepPoint.sleepValue = arc4random() % 15 + 15;
//        }
//        [array addObject:inbedArray];
//        [array addObject:fallAsleepArray1];
//        [array addObject:normalArray];
//        [array addObject:fallAsleepArray2];
//        
//        sleepInfo.sleepPoints = [NSArray arrayWithArray:array];
//        [sleepInfo setup];
//        
//        [mutableArr addObject:sleepInfo];
//    }
//    
//    self.sleepInfos = [NSArray arrayWithArray:mutableArr];
}

- (void)mainViewDidScroll:(WBMainView *)mainView {
    if (mainView.contentOffset.y <= 0) {
        _topConstraint.constant = IPHONE_HEIGHT - 43.0f;
    } else {
        CGFloat constant = IPHONE_HEIGHT - 43.0f + mainView.contentOffset.y;
        if (constant > IPHONE_HEIGHT) {
            constant = IPHONE_HEIGHT;
        }
        _topConstraint.constant = constant;
    }
    
    if (_topConstraint.constant != IPHONE_HEIGHT - 43.0f) {
        _connectDeviceView.enabled = NO;
    } else {
        _connectDeviceView.enabled = YES;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.sleepInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionCellIdentifier forIndexPath:indexPath];
    cell.scrollDelegate = self;
    cell.superViewController = self;
    cell.sleepInfo = [self.sleepInfos objectAtIndex:indexPath.row];
    [cell configCell];
    return cell;
}

#pragma mark - Connect device

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {
    if (!_connectDeviceView.enabled) {
        return;
    }
    
    CGPoint translation = [gestureRecognizer translationInView:_connectDeviceView];
    CGFloat top = self.view.top + translation.y;
    if (top <= 0 && top >= -IPHONE_HEIGHT) {
        self.view.top = top;
    }
    [gestureRecognizer setTranslation:CGPointZero inView:_connectDeviceView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
        gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGFloat offset = 0.0f;
        if (-self.view.top < IPHONE_HEIGHT / 2.0f) {
            offset = 0.0f;
        } else {
            offset = -IPHONE_HEIGHT;
        }
        
        [UIView animateWithDuration:0.17f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.view.top = offset;
                         }
                         completion:NULL];
    }
}

- (void)startSleepingClick {
    if (!_connectDeviceView.enabled) {
        return;
    }
    
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.top = -IPHONE_HEIGHT;
                     } completion:^(BOOL finished) {
                     }
     ];
}

- (void)cancelConnectClick {
    [UIView animateWithDuration:0.35f
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.view.top = 0.0f;
                     } completion:^(BOOL finished) {
                     }
     ];
}

- (void)connectDeviceViewDidConnected:(WBConnectDeviceView *)view {
    if (!_measuringView) {
        _measuringView = [[WBMeasuringView alloc] init];
        [self.navigationController.view addSubview:_measuringView];
        
    }
}

@end
