//
//  xhMediaViewController.m
//  AvPlayerDemo
//
//  Created by Xiaohe Hu on 12/18/14.
//  Copyright (c) 2014 Neoscape. All rights reserved.
//

#import "xhMediaViewController.h"
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAudioMix.h>
#import <AVFoundation/AVAssetTrack.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVFoundation.h>

@interface xhMediaViewController ()
{

    NSURL           *fileURL;
}
@property (nonatomic, strong)    AVPlayer                   *myAVPlayer;
@property (nonatomic, strong)    AVPlayerLayer              *myAVPlayerLayer;
@end

@implementation xhMediaViewController
@synthesize shouldRepeat;

- (id)initWithURL:(NSURL *)url
{
    if (self == [super init]) {
        fileURL = url;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self playWithURL:fileURL];
}

- (void)playWithURL:(NSURL *)url
{
    if (_myAVPlayer) {
        _myAVPlayer = nil;
        [_myAVPlayerLayer removeFromSuperlayer];
        _myAVPlayerLayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    if (url) {
        _myAVPlayer = [[AVPlayer alloc] initWithURL:url];
    }
    else {
        _myAVPlayer = [[AVPlayer alloc] initWithURL:fileURL];
    }
    _myAVPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_myAVPlayer];
    CGRect frame = [[UIScreen mainScreen] bounds];
    _myAVPlayerLayer.frame = frame;
    [self.view.layer addSublayer: _myAVPlayerLayer];
    
    [_myAVPlayer play];
    
    NSLog(@"Video started playing!");
    
    _myAVPlayer.actionAtItemEnd = AVPlayerActionAtItemEndNone;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_myAVPlayer currentItem]];
}


- (void)playerItemDidReachEnd:(NSNotification *)notification
{
    NSLog(@"The current item is ");
    AVPlayerItem *item = [notification object];
    [item seekToTime:kCMTimeZero];
//    [myAVPlayer play];
//    [myAVPlayer seekToTime:kCMTimeZero];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
