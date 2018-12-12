//
//  EditViewController.m
//  Sticker
//
//  Created by starlike on 2018/11/4.
//  Copyright © 2018年 stickerlike. All rights reserved.
//

#import "EditViewController.h"
#import "FilterViewController.h"
#import "MBProgressHUD.h"
#import "LUHUnderLineButtonView.h"
#import "EditCollectionViewCell.h"
#import "Sticker.h"
#import "Helper.h"
#import "AddStickerViewController.h"
#import "AFNetworking.h"

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define STICKER_HEADER 120
#define STICKER_HEIGHT (SCREEN_HEIGHT - 40)
#define STICKER_Y 30

@interface EditViewController () <UICollectionViewDelegate,UICollectionViewDataSource,StickerDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate> {
    MBProgressHUD *hud;
    UIPanGestureRecognizer *panRecognizer;
    UIPinchGestureRecognizer *pinchRecognizer;
    UIRotationGestureRecognizer *rotationRecognizer;
}

@property (nonatomic, strong) UIView *stickerview;
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UICollectionView *hatsview;
@property (nonatomic, strong) UICollectionView *glassview;
@property (nonatomic, strong) UICollectionView *necklacesview;
@property (nonatomic, strong) UICollectionView *crownsview;
@property (nonatomic, strong) UIButton *downbtn;
@property (nonatomic, strong) LUHUnderLineButtonView *linebutton;
@property (nonatomic, strong) Sticker *hatscrownimage;
@property (nonatomic, strong) Sticker *glassimage;
@property (nonatomic, strong) Sticker *neckimage;
@property (nonatomic, strong) Sticker *currentSticker;
@property (nonatomic, strong) UILabel *coinlabel;
@property (nonatomic, strong) UIImageView *coinimage;
@property (nonatomic, strong) UICollectionView *currentcollectionview;

@end

@implementation EditViewController

NSArray *hatsarray;
NSArray *glassarray;
NSArray *crownarray;
NSArray *neckarray;
int stickersize;
int editlen;
int currenttype;

-(void) readCoinFromServe{
    // LoginApi Call:-
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
    
    [dictdata setValue:[Helper getEmail] forKey:@"email"];

    NSLog(@"%@", dictdata);
    [manager GET:@"http://magicalxyz.com/sticker/backend/web/index.php?r=api/coincount" parameters:dictdata progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
         NSMutableDictionary *dictionary;
         dictionary = [NSJSONSerialization JSONObjectWithData:responseObject
                                                      options:kNilOptions
                                                        error:nil];
         NSLog(@"%@", dictionary);
         if ([dictionary[@"status"]  isEqual: @"1"])
         {
             NSDictionary* data_dic = dictionary[@"data"];
             int coin = (int)[data_dic[@"coins"] integerValue];
             [Helper setCoin:coin];
             _coinlabel.text = [NSString stringWithFormat:@"%ld", [Helper getCoin]];
         }
         
     }
         failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}

-(void) reduceCoinInServer{
    // LoginApi Call:-
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    NSMutableDictionary *dictdata=[[NSMutableDictionary alloc]init];
    
    [dictdata setValue:[Helper getEmail] forKey:@"email"];
    
    NSLog(@"%@", dictdata);
    [manager GET:@"http://magicalxyz.com/sticker/backend/web/index.php?r=api/unlockcoin" parameters:dictdata progress:nil success:^(NSURLSessionTask *task, id responseObject)
     {
        
         
     }
         failure:^(NSURLSessionTask *operation, NSError *error)
     {
         NSLog(@"Error: %@", error);
     }];

}

- (void)viewDidLoad {
    [super viewDidLoad];

    //_editimageview.image = _editimage;
    
    [self readCoinFromServe];
    
    hatsarray = [[NSArray alloc] initWithObjects:@"h1.png",@"h2.png",@"h3.png",@"h4.png",@"h5.png",@"h6.png",@"h7.png",@"h8.png",@"h9.png",@"h10.png",@"h11.png",@"h12.png",@"h13.png",@"h14.png",@"h15.png",@"h16.png",@"h17.png",@"h18.png",@"h19.png",@"h20.png",@"h21.png",@"h22.png",@"h23.png",@"h24.png",@"h25.png",@"h26.png",@"h27.png",@"h28.png",@"h29.png",@"h30.png",@"h31.png",@"h32.png",@"h33.png",@"h34.png",@"h35.png",@"h36.png",@"h37.png",@"h38.png",@"h39.png",@"h40.png",@"h41.png",@"h42.png",@"h43.png",@"h44.png",@"h45.png",nil];
    glassarray = [[NSArray alloc] initWithObjects:@"g1.png",@"g2.png",@"g3.png",@"g4.png",@"g5.png",@"g6.png",@"g7.png",@"g8.png",@"g9.png",@"g10.png",@"g11.png",@"g12.png",@"g13.png",@"g14.png",@"g15.png",@"g16.png",@"g17.png",@"g18.png",@"g19.png",@"g20.png",@"g21.png",@"g22.png",@"g23.png",@"g24.png",@"g25.png",@"g26.png",@"g27.png",@"g28.png",@"g29.png",@"g30.png",@"g31.png",@"g32.png",@"g33.png",@"g34.png",@"g35.png",@"g36.png",@"g37.png",@"g38.png",@"g39.png",@"g40.png",@"g41.png",@"g42.png",@"g43.png",@"g44.png",@"g45.png",nil];
    crownarray = [[NSArray alloc] initWithObjects:@"c1.png",@"c2.png",@"c3.png",@"c4.png",@"c5.png",@"c6.png",@"c7.png",@"c8.png",@"c9.png",@"h10.png",@"c11.png",@"c12.png",@"c13.png",@"c14.png",@"c15.png",@"c16.png",@"c17.png",@"c18.png",@"c19.png",@"c20.png",@"c21.png",@"c22.png",@"c23.png",@"c24.png",@"c25.png",@"c26.png",@"c27.png",@"c28.png",@"c29.png",@"c30.png",@"c31.png",@"c32.png",@"c33.png",@"c34.png",@"c35.png",@"c36.png",@"c37.png",@"c38.png",@"c39.png",@"c40.png",@"c41.png",@"c42.png",@"c43.png",@"c44.png",@"c45.png",nil];
    neckarray = [[NSArray alloc] initWithObjects:@"n1.png",@"n2.png",@"n3.png",@"n4.png",@"n5.png",@"n6.png",@"n7.png",@"n8.png",@"n9.png",@"n10.png",@"n11.png",@"n12.png",@"n13.png",@"n14.png",@"n15.png",@"n16.png",@"n17.png",@"n18.png",@"n19.png",@"n20.png",@"n21.png",@"n22.png",@"n23.png",@"n24.png",@"n25.png",@"n26.png",@"n27.png",@"n28.png",@"n29.png",@"n30.png",@"n31.png",@"n32.png",@"n33.png",@"n34.png",@"n35.png",@"n36.png",@"n37.png",@"n38.png",@"n39.png",@"n40.png",@"n41.png",@"n42.png",@"n43.png",@"n44.png",@"n45.png",nil];
    
    
    
//    _hatscrownimage = [[Sticker alloc] init];
//    _hatscrownimage.delegate = self;
//    _hatscrownimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 30, 80, 80);
//    [self.view addSubview:_hatscrownimage];
//    _glassimage = [[Sticker alloc] init];
//    _glassimage.delegate = self;
//    _glassimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 120, 80, 80);
//    [self.view addSubview:_glassimage];
//    _neckimage = [[Sticker alloc] init];
//    _neckimage.delegate = self;
//    _neckimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 200, 80, 80);
//    [self.view addSubview:_neckimage];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        stickersize = 80;
        editlen = 100;
    } else {
        stickersize = 160;
        editlen = 250;
    }
    
    [self initStickerView];
    
    
    
    [self setMoveGestureRecognizer];
}

-(void)viewWillAppear:(BOOL)animated {
    [self resizeEditImageFrame];
    NSLog(@"view viell appear");
    if (_coinlabel != nil) {
        NSLog(@"dd %ld", [Helper getCoin]);
        _coinlabel.text = [NSString stringWithFormat:@"%ld", [Helper getCoin]];
    }
}

- (void)stickerisSelected:(Sticker *)sticker {
//    for (Sticker *st in [editedImage subviews]) {
//        if ([st class] == [Sticker class])
//            [st setBorder:NO];
//    }
    if (_currentSticker != nil) {
        [_currentSticker setBorder:NO];
    }
    
    NSLog(@"sticker is selected");
    self.currentSticker = sticker;
    [self.currentSticker setBorder:YES];

//    [deleteStickerBtn setEnabled:YES];
//    [changeStickerBtn setEnabled:YES];
}

#pragma mark - Set Gesture Recongnizer

- (void)setMoveGestureRecognizer {
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDetected:)];
    [self.view addGestureRecognizer:panRecognizer];
    
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    rotationRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationDetected:)];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    
    panRecognizer.delegate = self;
    pinchRecognizer.delegate = self;
    rotationRecognizer.delegate = self;
}

- (void)removeAllGestureRecognizersFromView {
    [self.view removeGestureRecognizer:panRecognizer];
    [self.view removeGestureRecognizer:pinchRecognizer];
    [self.view removeGestureRecognizer:rotationRecognizer];
}

#pragma mark - Gesture Recognizers

- (void)panDetected:(UIPanGestureRecognizer *)panRecognizer2 {
    CGPoint translation = [panRecognizer velocityInView:_editimageview];
    CGPoint imageViewPosition = self.currentSticker.center;

    imageViewPosition.x += translation.x * .02;
    imageViewPosition.y += translation.y * .02;
    
    if (imageViewPosition.x < 0 || imageViewPosition.y < 0 ||
        imageViewPosition.x > [UIScreen mainScreen].bounds.size.width ||
        imageViewPosition.y > [UIScreen mainScreen].bounds.size.height)
        return;
    
//    if (stickerView.allowMove)
    self.currentSticker.center = imageViewPosition;
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer2 {
    CGFloat scale = pinchRecognizer.scale;
    
    if (CGAffineTransformScale(self.currentSticker.transform, scale, scale).a > 4.0) return;
    self.currentSticker.transform = CGAffineTransformScale(self.currentSticker.transform, scale, scale);
    pinchRecognizer.scale = 1.0;
}

- (void)rotationDetected:(UIRotationGestureRecognizer *)rotationRecognizer2 {
    CGFloat angle = rotationRecognizer.rotation;
    self.currentSticker.transform = CGAffineTransformRotate(self.currentSticker.transform, angle);
    rotationRecognizer.rotation = 0.0;
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    if ([[event allTouches] count] == 1) {
        [self.currentSticker setBorder:NO];
        self.currentSticker = nil;
        
//        [deleteStickerBtn setEnabled:NO];
//        [changeStickerBtn setEnabled:NO];
//
//        [currentlyEditingLabel hideEditingHandles];
//    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)resizeEditImageFrame {
    NSLog(@"resize edit image %f %f %f %f", _editimage.size.width, _editimage.size.height, _editimageview.image.size.width, _editimageview.image.size.height);
//    if (_editimage.size.width >= _editimage.size.height) {
//        CGFloat width = SCREEN_WIDTH;
//        CGFloat height = _editimage.size.height* SCREEN_WIDTH / _editimage.size.width;
//        CGFloat x = 0;
//        CGFloat y = (SCREEN_HEIGHT - height)/2;
//        _editimageview.frame = CGRectMake(x, y, width, height);
//        NSLog(@"x %f %f %f %f", x,y,width,height);
//    } else {
//        CGFloat height = SCREEN_HEIGHT - 200;
//        CGFloat width =  _editimage.size.width * SCREEN_HEIGHT / _editimage.size.height;
//        CGFloat x = 0;
//        CGFloat y = (SCREEN_HEIGHT - height) / 2;
//        _editimageview.frame = CGRectMake(x, y, width, height);
//         NSLog(@"y %f %f %f %f", x,y,width,height);
//    }
    

    _editimageview.image = _editimage;

    
    CGRect rect = CGRectMake(0, (SCREEN_HEIGHT - (SCREEN_HEIGHT - editlen))/2, SCREEN_WIDTH, SCREEN_HEIGHT-editlen);
    _editimageview.frame = rect;
    _editimageview.contentMode = UIViewContentModeScaleAspectFit;
    _editimageview.userInteractionEnabled = YES;
    
    CGRect temp = _editimageview.frame;
    CGPoint point = _editimageview.center;
    temp.size = [Helper imageSizeAfterAspectFit:_editimageview];
    _editimageview.frame = temp;
    _editimageview.center = point;
    
    NSLog(@"dd %f %f %f %f", _editimageview.frame.origin.x, _editimageview.frame.origin.y, _editimageview.frame.size.width, _editimageview.frame.size.height);
}

-(void)initStickerView {
    _stickerview = [[UIView alloc] init];
    _stickerview.layer.cornerRadius = 8;
    _stickerview.layer.masksToBounds = YES;
    _stickerview.backgroundColor = [UIColor whiteColor];
    _stickerview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, STICKER_HEIGHT);
    [self.view addSubview:_stickerview];
    
    _scrollview = [[UIScrollView alloc] init];
    _scrollview.frame = CGRectMake(0, STICKER_HEADER, SCREEN_WIDTH, STICKER_HEIGHT - STICKER_HEADER);
    _scrollview.contentSize = CGSizeMake(SCREEN_WIDTH*4, STICKER_HEIGHT - STICKER_HEADER);
    _scrollview.backgroundColor = [UIColor grayColor];
    [_stickerview addSubview:_scrollview];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.itemSize = CGSizeMake(80, 80);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    UICollectionViewFlowLayout *flowLayout1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout1.minimumLineSpacing = 20;
    flowLayout1.minimumInteritemSpacing = 20;
    flowLayout1.itemSize = CGSizeMake(80, 80);
    flowLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout1.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    UICollectionViewFlowLayout *flowLayout2 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout2.minimumLineSpacing = 20;
    flowLayout2.minimumInteritemSpacing = 20;
    flowLayout2.itemSize = CGSizeMake(80, 80);
    flowLayout2.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout2.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    UICollectionViewFlowLayout *flowLayout3 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout3.minimumLineSpacing = 20;
    flowLayout3.minimumInteritemSpacing = 20;
    flowLayout3.itemSize = CGSizeMake(80, 80);
    flowLayout3.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout3.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
    _hatsview = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    _hatsview.frame = CGRectMake(0, 0, SCREEN_WIDTH, STICKER_HEIGHT - STICKER_HEADER);
    _hatsview.backgroundColor = [UIColor whiteColor];
    _hatsview.dataSource = self;
    _hatsview.delegate = self;
    _hatsview.tag = 0;
    [_hatsview registerNib:[UINib nibWithNibName:@"EditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hats"];
    
    _glassview = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout1];
    _glassview.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, STICKER_HEIGHT - STICKER_HEADER);
    _glassview.backgroundColor = [UIColor whiteColor];
    _glassview.dataSource = self;
    _glassview.delegate = self;
    _glassview.tag = 1;
    [_glassview registerNib:[UINib nibWithNibName:@"EditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"glass"];
    
    _necklacesview = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout2];
    _necklacesview.frame = CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, STICKER_HEIGHT - STICKER_HEADER);
    _necklacesview.backgroundColor = [UIColor whiteColor];
    _necklacesview.dataSource = self;
    _necklacesview.delegate = self;
    _necklacesview.tag = 2;
    [_necklacesview registerNib:[UINib nibWithNibName:@"EditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"neck"];
    
    _crownsview = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout3];
    _crownsview.frame = CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, STICKER_HEIGHT - STICKER_HEADER);
    _crownsview.backgroundColor = [UIColor whiteColor];
    _crownsview.dataSource = self;
    _crownsview.delegate = self;
    _crownsview.tag = 3;
    [_crownsview registerNib:[UINib nibWithNibName:@"EditCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"crown"];
    
    [_scrollview addSubview:_hatsview];
    [_scrollview addSubview:_glassview];
    [_scrollview addSubview:_necklacesview];
    [_scrollview addSubview:_crownsview];
    
    _downbtn = [[UIButton alloc] init];
    _downbtn.frame = CGRectMake((SCREEN_WIDTH - 30)/2, 30, 30, 10);
    [_downbtn setBackgroundImage:[UIImage imageNamed:@"arrow-icon"] forState:UIControlStateNormal];
    [_downbtn addTarget:self action:@selector(downbtnclick) forControlEvents:UIControlEventTouchUpInside];
    [_stickerview addSubview:_downbtn];
    
    _linebutton = [[LUHUnderLineButtonView alloc] initWithItems:[NSArray arrayWithObjects:@"Hats",@"Glasses",@"Necklaces",@"Crowns",nil]];
    _linebutton.frame = CGRectMake(0, 70, SCREEN_WIDTH, 30);
    [_linebutton addTarget:self action:@selector(linebuttonclick)];
    [_stickerview addSubview:_linebutton];
    
    _coinlabel = [[UILabel alloc] init];
    _coinlabel.frame = CGRectMake(SCREEN_WIDTH-40, 10, 40, 40);
    _coinlabel.text = [NSString stringWithFormat:@"%ld", [Helper getCoin]];
    _coinlabel.font = [UIFont fontWithName:@"Arial" size:14];
    
    _coinimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"h1"]];
    _coinimage.frame = CGRectMake(SCREEN_WIDTH-60, 10, 40, 40);
    
    [_stickerview addSubview:_coinlabel];
    //[_stickerview addSubview:_coinimage];
    
    _currentcollectionview = _hatsview;
}

#pragma mark ---- UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger num = [Helper getSticker:collectionView.tag];
    if (num == 0) {
        [Helper setSticker:2 stickerType:collectionView.tag];
        num  = 2;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger itemsnum = [collectionView numberOfItemsInSection:0];
    NSLog(@"item num %ld  %ld", itemsnum, collectionView.tag);
    EditCollectionViewCell *cell;
    switch (collectionView.tag) {
        case 0:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hats" forIndexPath:indexPath];
            cell.image.image = [UIImage imageNamed:[hatsarray objectAtIndex:indexPath.row]];
            break;
        case 1:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"glass" forIndexPath:indexPath];
            cell.image.image = [UIImage imageNamed:[glassarray objectAtIndex:indexPath.row]];
            break;
        case 2:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"neck" forIndexPath:indexPath];
            cell.image.image = [UIImage imageNamed:[neckarray objectAtIndex:indexPath.row]];
            break;
        case 3:
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"crown" forIndexPath:indexPath];
            cell.image.image = [UIImage imageNamed:[crownarray objectAtIndex:indexPath.row]];
            break;
        default:
            break;
    }
    
    if (itemsnum == (indexPath.row + 1)) {
        cell.image.image = [UIImage imageNamed:@"add-stickers-button"];
    }
    

    
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"aler %ld", buttonIndex);
    if (buttonIndex == 1) {
        //yes
        if ([Helper getCoin] < 250) {
            //
            AddStickerViewController *sv = [[AddStickerViewController alloc] initWithNibName:@"AddStickerViewController" bundle:nil];
            [self presentViewController:sv animated:NO completion:nil];
        } else {
            int coin = [Helper getCoin] - 250;
            [Helper setCoin:coin];
            int num = [Helper getSticker:currenttype] + 1;
            [Helper setSticker:num stickerType:currenttype];
            _coinlabel.text = [NSString stringWithFormat:@"%ld", coin];
            [_currentcollectionview reloadData];
            [self reduceCoinInServer];
            
        }
    } else if (buttonIndex == 2) {
      //no
    } else if (buttonIndex == 0) {
        //not enough coin
        AddStickerViewController *sv = [[AddStickerViewController alloc] initWithNibName:@"AddStickerViewController" bundle:nil];
        [self presentViewController:sv animated:NO completion:nil];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView numberOfItemsInSection:0] == (indexPath.row + 1)) {
        NSLog(@"add sticker click");
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:@"Unlock the next sticker for 250 coins" delegate:self cancelButtonTitle:@"Not enough coins" otherButtonTitles:@"Yes", @"No", nil];
        [av show];
        return;
    }
    
    
    switch (collectionView.tag) {
        case 0:
//            if (_hatscrownimage != nil) {
//                [_hatscrownimage removeFromSuperview];
//            }
            
            _hatscrownimage = [[Sticker alloc] init];
            _hatscrownimage.delegate = self;
            _hatscrownimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 30, stickersize, stickersize);
            [self.view addSubview:_hatscrownimage];
            
            [_hatscrownimage setStickerImage:[UIImage imageNamed:[hatsarray objectAtIndex:indexPath.row]]];

            [self downbtnclick];
            
            break;
        case 1:
//            if (_glassimage != nil) {
//                [_glassimage removeFromSuperview];
//            }
            
            _glassimage = [[Sticker alloc] init];
            _glassimage.delegate = self;
            _glassimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 30, stickersize, stickersize);
            [self.view addSubview:_glassimage];
            
            [_glassimage setStickerImage:[UIImage imageNamed:[glassarray objectAtIndex:indexPath.row]]];
            
            [self downbtnclick];
            break;
        case 2:
            
//            if (_neckimage != nil) {
//                [_neckimage removeFromSuperview];
//            }
            
            _neckimage = [[Sticker alloc] init];
            _neckimage.delegate = self;
            _neckimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 30, stickersize, stickersize);
            [self.view addSubview:_neckimage];
            
            _neckimage.image = [UIImage imageNamed:[neckarray objectAtIndex:indexPath.row]];
            [self downbtnclick];
            break;
        case 3:
//            if (_hatscrownimage != nil) {
//                [_hatscrownimage removeFromSuperview];
//            }
            
            _hatscrownimage = [[Sticker alloc] init];
            _hatscrownimage.delegate = self;
            _hatscrownimage.frame = CGRectMake((SCREEN_WIDTH-80)/2, _editimageview.frame.origin.y + 30, stickersize, stickersize);
            [self.view addSubview:_hatscrownimage];
            
            _hatscrownimage.image = [UIImage imageNamed:[crownarray objectAtIndex:indexPath.row]];

            [self downbtnclick];
            break;
        default:
            break;
    }
}



-(void)linebuttonclick {
    switch (_linebutton.selectedIndex) {
        case 0:
            [_scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
            _scrollview.bouncesZoom = NO;
            currenttype = 0;
            _currentcollectionview = _hatsview;
            break;
        case 1:
            [_scrollview setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
            _scrollview.bouncesZoom = NO;
            currenttype = 1;
            _currentcollectionview = _glassview;
            break;
        case 2:
            [_scrollview setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
            _scrollview.bouncesZoom = NO;
            currenttype = 2;
            _currentcollectionview = _necklacesview;
            break;
        case 3:
            [_scrollview setContentOffset:CGPointMake(SCREEN_WIDTH*3, 0) animated:YES];
            _scrollview.bouncesZoom = NO;
            currenttype = 3;
            _currentcollectionview = _crownsview;
            break;
        default:
            break;
    }
}

-(void)downbtnclick {
    [UIView animateWithDuration:0.5 animations:^{
        // 设置view弹出来的位置
        self.stickerview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, STICKER_HEIGHT);
    }];
}

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:FALSE completion:nil];
}
- (IBAction)filter:(id)sender {
    
    if (_currentSticker != nil) {
        [_currentSticker setBorder:NO];
    }

    
    FilterViewController *fv = [[FilterViewController alloc] init];
    fv.filterimage = [self captureImage];
    
    if (_hatscrownimage != nil) {
        [_hatscrownimage removeFromSuperview];
    }
    if (_glassimage != nil) {
        [_glassimage removeFromSuperview];
    }
    if (_neckimage != nil) {
        [_neckimage removeFromSuperview];
    }
    
    fv.rect = _editimageview.frame;
    fv.evc = self;
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self presentViewController:fv animated:FALSE completion:nil];
    [hud hideAnimated:YES];
}

- (IBAction)stickerclick:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.stickerview.frame = CGRectMake(0, STICKER_Y, SCREEN_WIDTH, STICKER_HEIGHT);
        [self.view bringSubviewToFront:_stickerview];
    }];
}

- (IBAction)undo:(id)sender {
//    _hatscrownimage.image = nil;
//    _glassimage.image = nil;
//    _neckimage.image = nil;
//
//    [_hatscrownimage setBorder:NO];
//    [_glassimage setBorder:NO];
//    [_neckimage setBorder:NO];
    
    if (_currentSticker != nil) {
        [_currentSticker setBorder:NO];
        _currentSticker.image = nil;
    }
    
}


- (UIImage *)captureImage {
    UIImage* image = nil;
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.view.layer renderInContext: UIGraphicsGetCurrentContext()];
    image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([UIGraphicsGetImageFromCurrentImageContext() CGImage], _editimageview.frame)];
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    
    return nil;
}

- (IBAction)share:(id)sender {
//    UIImage *imageToShare = [self captureImage];
//    NSArray *activityItems = @[imageToShare];
//
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
//    activityVC.popoverPresentationController.sourceView = self.view;
//
//    [self presentViewController:activityVC animated:YES completion:nil];
    
    if (_currentSticker != nil) {
        [_currentSticker setBorder:NO];
    }
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        UIImage *aImgRef = [self captureImage];
        UIImageWriteToSavedPhotosAlbum(aImgRef, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        //usleep(400000);
    });
    
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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
