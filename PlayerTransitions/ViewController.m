//
//  ViewController.m
//  PlayerTransitions
//
//  Created by yoyochecknow on 2019/11/20.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "ViewController.h"
#import "SeanPlyaerView.h"
@interface ViewController ()
@property (nonatomic,strong) UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = CGRectMake(0, 100, 320,180);
    imageView.image = [UIImage imageNamed:@"shipin"];
    [self.view addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClick:)];
    [imageView addGestureRecognizer:tap];
    _imageView = imageView;
}

- (void)imageViewClick:(UITapGestureRecognizer *)tap{
    [SeanPlyaerView playerWithURL:@"https://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4" imageView:self.imageView];
}



@end
