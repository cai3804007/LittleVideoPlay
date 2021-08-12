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


@property (nonatomic,weak)  UIImageView *orginImage;
@property (nonatomic,weak)  UIView *orginContentView;
@end




@implementation SeanPlyaerView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImageView *)image contentView:(UIView *)contentView
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self addSubview:_bgView];
     
        [self configUIWithImageView:image];
        _orginContentView = contentView;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmiss)];
        [self addGestureRecognizer:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestur:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)configUIWithImageView:(UIImageView *)image{
    _orginImage = image;
    _containerView = [[UIImageView alloc]init];
    CGFloat scale = image.image.size.height/image.image.size.width;
    CGFloat height = ScreenWidth * scale > ScreenHeight ? ScreenHeight : ScreenWidth * scale;
    CGFloat orginY = (ScreenHeight - height)/2.0;
    
    _containerView.frame = CGRectMake(0, orginY,ScreenWidth , height);
    [self addSubview:_containerView];
    
}

- (void)panGestur:(UIPanGestureRecognizer *)panGesture{
    CGPoint  translation = [panGesture translationInView:self.containerView];
    CGFloat percentComplete = 0.0;
    
    self.containerView.center = CGPointMake(self.containerView.center.x + translation.x,
                                        self.containerView.center.y + translation.y);
    [panGesture setTranslation:CGPointZero inView:self.containerView];
    
    percentComplete = (self.containerView.center.y - self.frame.size.height/ 2) / (self.frame.size.height/2);
    percentComplete = fabs(percentComplete);
//    CGFloat percent = 1- percentComplete;
    NSLog(@"%f",percentComplete);
    if (percentComplete > 0 && percentComplete < 0.2) {
        CGFloat scale =  1 -  percentComplete * 0.5 /0.3;
        NSLog(@"scale========%f",scale);
        self.containerView.transform = CGAffineTransformMakeScale(scale, scale);
        
    }else{
        self.containerView.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            self.bgView.alpha = 1 - percentComplete;
            break;
        case UIGestureRecognizerStateEnded:{
            
            if (percentComplete > 0.2) {
                [self dissmiss];
            }else{
                self.containerView.center = CGPointMake(self.center.x,
                                                    self.center.y);
                self.containerView.transform = CGAffineTransformIdentity;
                self.bgView.alpha = 1;
            }
            break;
        }
        default:
            break;
    }
}


+ (void)playerWithURL:(NSString *)url imageView:(UIImageView *)imageView contentView:(UIView *)contentView{
    SeanPlyaerView *view = [[SeanPlyaerView alloc]initWithFrame:[UIScreen mainScreen].bounds image:imageView contentView:contentView];
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
    CGRect imageFrame = [self.orginImage convertRect:self.orginImage.bounds toView:self];
    NSLog(@"orginImage=====%@   imageFrame=======%@",NSStringFromCGRect(self.orginImage.frame),NSStringFromCGRect(self.containerView.frame));
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.frame = imageFrame;
    } completion:^(BOOL finished) {
        [self.player pause];
        [self removeFromSuperview];
    }];
}

- (void)addOber{
    //1.注册观察者，监测播放器属性
    //观察Status属性，可以在加载成功之后得到视频的长度
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //观察loadedTimeRanges，可以获取缓存进度，实现缓冲进度条
    [self.player.currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem  addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
     [self.player.currentItem  addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];

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
                [self.progressView hideAnimated:YES];
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
        NSLog(@"开始缓冲:%f,缓冲时长:%f,总时间:%f", loadStartSeconds, loadDurationSeconds, currentLoadTotalTime);
        //更新显示：当前缓冲总时长
//        _progressView.progress = currentLoadTotalTime/CMTimeGetSeconds(self.player.currentItem.duration);
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        [self.progressView showAnimated:YES];
    } else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]) {
        [self.progressView hideAnimated:YES];
        NSLog(@"缓冲达到可播放程度了");
        //由于 AVPlayer 缓存不足就会自动暂停，所以缓存充足了需要手动播放，才能继续播放
        [self.player play];
        
    }
}

- (MBProgressHUD *)progressView{
    if (!_progressView) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = [UIColor clearColor];
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.animationType = MBProgressHUDAnimationZoomOut;
        _progressView = hud;
    }
    return _progressView;
}

-(void)dealloc{
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

@end
