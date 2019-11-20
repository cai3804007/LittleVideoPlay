//
//  SeanPlyaerView.m
//  PlayerTransitions
//
//  Created by yoyochecknow on 2019/11/20.
//  Copyright © 2019 SeanOrganization. All rights reserved.
//

#import "SeanPlyaerView.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD+Sean.h"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SeanPlyaerView ()

@property (nonatomic,strong) UIImageView *containerView;
@property (nonatomic,strong)AVPlayer *player;//播放器对象
@property (nonatomic,strong)AVPlayerItem *currentPlayerItem;
@property (nonatomic,strong) MBProgressHUD *progressView;
@property (nonatomic,strong) UIView *bgView;
@end




@implementation SeanPlyaerView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImageView *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self addSubview:_bgView];
      
     
        [self configUIWithImageView:image];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)configUIWithImageView:(UIImageView *)image{
    _containerView = [[UIImageView alloc]init];
    CGFloat scale = image.image.size.height/image.image.size.width;
    CGFloat height = ScreenWidth * scale > ScreenHeight ? ScreenHeight : ScreenWidth * scale;
    CGFloat orginY = (ScreenHeight - height)/2.0;
    
    _containerView.frame = CGRectMake(0, orginY,ScreenWidth , height);
    [self addSubview:_containerView];
    
}




+ (void)playerWithURL:(NSString *)url imageView:(UIImageView *)imageView{
    SeanPlyaerView *view = [[SeanPlyaerView alloc]initWithFrame:[UIScreen mainScreen].bounds image:imageView];
    [view playerWithURL:url imageView:imageView];
    
}

- (void)playerWithURL:(NSString *)url imageView:(UIImageView *)imageView{
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    _containerView.image = [UIImage imageNamed:@"shipin"];
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    self.currentPlayerItem = playerItem;
    self.player = [[AVPlayer alloc] initWithPlayerItem:playerItem];
    [self addOber];
    [self.progressView showAnimated:YES];
    AVPlayerLayer *avLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    avLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    avLayer.frame = _containerView.bounds;
    [_containerView.layer addSublayer:avLayer];
    [keywindow addSubview:self];
}

- (void)dissmiss{
    
    [self.player pause];
    [self removeFromSuperview];
}

- (void)addOber{
    //1.注册观察者，监测播放器属性
    //观察Status属性，可以在加载成功之后得到视频的长度
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}



//2.添加属性观察
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取playerItem的status属性最新的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                //获取视频长度
//                CMTime duration = playerItem.duration;
                //更新显示:视频总时长(自定义方法显示时间的格式)
                [self.progressView hideAnimated:YES];
                //开始播放视频
                [self.player play];
                break;
            }
            case AVPlayerStatusFailed:{//视频加载失败，点击重新加载
                [MBProgressHUD hideHUD];
                [MBProgressHUD showMessage:@"视频加载失败"];
                break;
            }
            case AVPlayerStatusUnknown:{
                NSLog(@"加载遇到未知问题:AVPlayerStatusUnknown");
                break;
            }
            default:
                break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        //获取视频缓冲进度数组，这些缓冲的数组可能不是连续的
        NSArray *loadedTimeRanges = playerItem.loadedTimeRanges;
        //获取最新的缓冲区间
        CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
        //缓冲区间的开始的时间
        NSTimeInterval loadStartSeconds = CMTimeGetSeconds(timeRange.start);
        //缓冲区间的时长
        NSTimeInterval loadDurationSeconds = CMTimeGetSeconds(timeRange.duration);
        //当前视频缓冲时间总长度
        NSTimeInterval currentLoadTotalTime = loadStartSeconds + loadDurationSeconds;
        //NSLog(@"开始缓冲:%f,缓冲时长:%f,总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        //更新显示：当前缓冲总时长
//        _progressView.progress = currentLoadTotalTime/CMTimeGetSeconds(self.player.currentItem.duration);
        
       
        
    }
}

- (MBProgressHUD *)progressView{
    if (!_progressView) {
        _progressView = [MBProgressHUD showProgressBarToView:self];
    }
    return _progressView;
}

-(void)dealloc{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
