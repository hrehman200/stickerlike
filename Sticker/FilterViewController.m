//
//  FilterViewController.m
//  Sticker
//
//  Created by starlike on 2018/11/5.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import "FilterViewController.h"
#import "AlbumFiterViewCell.h"
#import "AlbumFiterModel.h"
#import "AlbumFilterManager.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "Helper.h"

@interface FilterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    MBProgressHUD *hud;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *albumFiterImages;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *cancelbtn;
@property (nonatomic, strong) UIButton *savebtn;

@end

@implementation FilterViewController

int width;
int height;

static NSString * const reuseIdentifier = @"AlbumFiterViewCellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        width = 60;
        height = 50;
    } else {
        width = 100;
        height = 100;
    }
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.cancelbtn];
    [self.view addSubview:self.savebtn];
    
}

-(void)viewDidAppear:(BOOL)animated{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_queue_t queue = dispatch_queue_create("filter", DISPATCH_QUEUE_CONCURRENT);
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        // 这里放异步执行任务代码
        [self initialization];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:self.collectionView];
            [hud hideAnimated:YES];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.albumFiterImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumFiterViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.fiter = self.albumFiterImages[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(75, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 12, 0, 12);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *albumFiterImage = _filterimage;
    
    self.imageView.image = [self renderEditAfterAlbumImage:albumFiterImage didSelectItemAtIndex:indexPath.row];
}

// 渲染图片
- (UIImage *)renderEditAfterAlbumImage:(UIImage *)albumImage didSelectItemAtIndex:(NSInteger)filterImageIndex {
    
    GPUImageColormatrixFilterType filterType = [[AlbumFilterManager shareManager] colormatrixFilterTypeByIndex:filterImageIndex];
    return [[AlbumFilterManager shareManager] imageByFilteringImage:albumImage filterType:filterType];
}

#pragma mark -
- (void)initialization {
    NSLog(@"init start");
    //
    //UIImage *thumbnailImage = [UIImage imageNamed:@"maomao"];
    UIImage *thumbnailImage = _filterimage;
    for (int i = 0; i < 14; i++) {
        AlbumFiterModel *fiter = [[AlbumFiterModel alloc] init];
        GPUImageColormatrixFilterType filterType = [[AlbumFilterManager shareManager] colormatrixFilterTypeByIndex:i];
        fiter.thumbnailName = [[AlbumFilterManager shareManager] getFilterName:filterType];
        UIImage *tempThumbnailImage = [[AlbumFilterManager shareManager] imageByFilteringImage:thumbnailImage filterType:filterType];
        fiter.thumbnailImage = tempThumbnailImage;
        [self.albumFiterImages addObject:fiter];
    }
    //
    NSLog(@"init end");
}

#pragma mark - Lazy Load

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//        _imageView.frame = ;
        _imageView.image = _filterimage;
//        _imageView.clipsToBounds = YES;
//        [self.view addSubview:_imageView];
        CGRect rect = CGRectMake(0, (FXScreenHeight - FXScreenWidth)/2, FXScreenWidth, FXScreenWidth);
        _imageView.frame = rect;
        
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        CGRect temp = _imageView.frame;
        CGPoint point = _imageView.center;
        temp.size = [Helper imageSizeAfterAspectFit:_imageView];
        _imageView.frame = temp;
        _imageView.center = point;
        
        
        NSLog(@"dd %f %f %f %f", _imageView.frame.origin.x, _imageView.frame.origin.y, _imageView.frame.size.width, _imageView.frame.size.height);
    }
    return _imageView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        flowLayout.minimumInteritemSpacing = 12;
        flowLayout.minimumLineSpacing = 12;
        CGFloat collectionViewHeight = 100;
        CGRect frame = CGRectMake(0, FXScreenHeight-100, FXScreenWidth, collectionViewHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView registerClass:[AlbumFiterViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

-(UIButton *)cancelbtn {
    if (!_cancelbtn) {
        _cancelbtn = [[UIButton alloc] init];
        _cancelbtn.frame = CGRectMake(0, 20, width, height);
        _cancelbtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [_cancelbtn setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelbtn addTarget:self action:@selector(cacelclick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cancelbtn];
    }
    return _cancelbtn;
}

-(UIButton *)savebtn {
    if (!_savebtn) {
        _savebtn = [[UIButton alloc] init];
        _savebtn.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width-width, 20, width, height);
        [_savebtn setTitle:@"Next" forState:UIControlStateNormal];
        _savebtn.titleLabel.font=[UIFont systemFontOfSize:18];
        [_savebtn addTarget:self action:@selector(savebtnclick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_savebtn];
    }
    return _savebtn;
}

-(void)cacelclick {
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

-(void)savebtnclick {
//    dispatch_async(dispatch_get_global_queue(0,0), ^{
//        UIImage *aImgRef = self.imageView.image;
//        UIImageWriteToSavedPhotosAlbum(aImgRef, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//        //usleep(400000);
//    });
    self.evc.editimage = self.imageView.image;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"save fail");
    }else{
        NSLog(@"save success");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Save Success" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:^{
        }];
    }
}

- (NSMutableArray *)albumFiterImages {
    if (!_albumFiterImages) {
        _albumFiterImages = [NSMutableArray array];
    }
    return _albumFiterImages;
}

@end
